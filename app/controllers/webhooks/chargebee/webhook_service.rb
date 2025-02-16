module Webhooks
  module Chargebee
    class WebhookService
      attr_reader :event

      def initialize(event)
        @event = event["event_type"]
        @content = event["content"]
      end

      def process
        case @event
        when "subscription_created"
          handle_subscription_created
        when "subscription_cancelled"
          handle_subscription_cancelled
        when "subscription_deleted"
          handle_subscription_deleted
        when "payment_succeeded"
          handle_payment_succeeded
        when "payment_failed"
          handle_payment_failed
        when "payment_refunded"
          handle_payment_refunded
        else
          Rails.logger.info("Unhandled Chargebee event: #{@event}")
        end
      end

      private

      def handle_subscription_created
        subscription = @content["subscription"]
        customer = @content["customer"]
        email = customer["email"]
        user = User.find_by(email:)

        subscription_metadata = subscription["metadata"]
        user_params = build_user_params(customer, subscription_metadata)

        if user
          user.update!(user_params.merge(chargebee_id: customer["id"]))
          SlackNotificationJob.perform_async("User exists but chargebee_id created or updated: #{email}")
        else
          user = User.create!(user_params.merge(chargebee_id: customer["id"].to_s))
          SlackNotificationJob.perform_async("User created a subscription in ChargeBee: #{email}")
        end

        check_for_coupons(@content, user)
      end

      def build_user_params(customer, subscription_metadata)
        address = customer["billing_address"]
        country_code = address&.dig("country")

        {
          email: customer["email"],
          address_1: address&.dig("line1"),
          address_2: "",
          city: address&.dig("city"),
          state: address&.dig("state"),
          country: country_code ? PhonePrefixes::COUNTRIES[country_code][:code] : nil,
          first_name: address&.dig("first_name"),
          last_name: address&.dig("last_name"),
          phone: address&.dig("phone"),
          phone_prefix: country_code ? PhonePrefixes::COUNTRIES[country_code][:code] : nil,
          company_name: address&.dig("company") || "",
          subscription_number_of_trees: subscription_metadata&.dig("trees_per_year") || 1,
          subscription_tree_type: map_tree_type(subscription_metadata&.dig("tree_type")),
          subscription_type: map_subscription_type(subscription_metadata&.dig("type")),
          subscription_status: :active
        }
      end

      def handle_subscription_cancelled
        customer = @content["customer"]
        user = User.find_by(email: customer["email"])
        return unless user&.chargebee_id

        user.update!(subscription_status: :cancelled)
        SlackNotificationJob.perform_async("Chargebee subscription cancelled for #{user.email}")
      end

      def handle_subscription_deleted
        customer = @content["customer"]
        user = User.find_by(email: customer["email"])
        return unless user&.chargebee_id

        user.update!(subscription_status: :deleted)
        SlackNotificationJob.perform_async("Chargebee subscription deleted for #{user.email}")
      end

      def handle_payment_succeeded
        customer = @content["customer"]
        subscription = @content["subscription"]

        user = User.find_by!(chargebee_id: customer["id"])

        ActiveRecord::Base.transaction do
          # Calculate monthly tree credits from yearly subscription
          subscription_metadata = subscription&.dig("metadata")
          trees_per_year = subscription_metadata&.dig("trees_per_year").to_i
          monthly_tree_credits = (trees_per_year / 12.0).round(6)

          # Get any extra tree credits from metadata
          extra_tree_credits = subscription_metadata&.dig("tree_credits").to_f || 0

          # Add monthly credits to user's existing credits
          total_credits = user.credits + monthly_tree_credits + extra_tree_credits

          Order.create!(
            user: user,
            quantity: monthly_tree_credits + extra_tree_credits,
            order_status: :fulfilled,
            product_type: :subscription,
            hook_order_id: subscription["id"],
            tree_type: user.subscription_tree_type,
            order_completed_date: Time.current,
            order_processed: true
          )

          # Update user's credits
          user.update!(credits: total_credits)

          SlackNotificationJob.perform_async(
            "Credits updated for #{user.email}: Added #{monthly_tree_credits} monthly + #{extra_tree_credits} extra = #{total_credits} total"
          )
        end
      end

      def handle_payment_failed
        payment = @content["payment"]
        transaction = @content["transaction"]
        customer = @content["customer"]

        user = User.find_by!(chargebee_id: customer["id"])

        SlackNotifier.notify("#payments", "Payment failed for #{user.email}: #{transaction['error_message']}")
      end

      def handle_payment_refunded
        payment = @content["payment"]
        transaction = @content["transaction"]
        customer = @content["customer"]

        user = User.find_by!(chargebee_id: customer["id"])

        SlackNotifier.notify("#payments", "Refund processed for #{user.email}: #{transaction['amount'] / 100.0} #{transaction['currency_code']}")
      end

      def check_for_coupons(data, user)
        return unless data["subscription"] && data["subscription"]["coupons"].present?

        coupon = data["subscription"]["coupons"].first
        return unless coupon && coupon["metadata"]

        tree_credits = coupon["metadata"]["tree_credits"]
        tree_type = coupon["metadata"]["tree_type"]

        create_coupon_order(user, tree_credits, tree_type)
      end

      def create_coupon_order(user, tree_credits, tree_type)
        return if Order.exists?(hook_order_id: user.chargebee_id)

        order = Order.new(
          user: user,
          hook_order_id: user.chargebee_id,
          quantity: tree_credits,
          order_status: :fulfilled,
          product_type: :subscription,
          tree_type: map_tree_type(tree_type),
          order_completed_date: Time.current,
          order_processed: true
        )

        if order.save
          SlackNotificationJob.perform_async(
            "Coupon order created for user: #{user.email}, " \
            "tree credits: #{tree_credits}, " \
            "tree type: #{tree_type}"
          )
        else
          SlackNotificationJob.perform_async(
            "Failed to create coupon order for user: #{user.email}"
          )
        end
      rescue => e
        Rails.logger.error("Error creating coupon order: #{e.message}")
        SlackNotificationJob.perform_async(
          "Error creating coupon order for #{user.email}: #{e.message}"
        )
      end

      def map_subscription_type(type)
        return :regular unless type.present?

        case type.downcase
        when 'gift'
          :gift
        when 'family'
          :family
        else
          :regular
        end
      end

      def map_tree_type(tree_type)
        return :yemani unless tree_type.present?
        
        tree_type.to_sym
      rescue
        :yemani
      end
    end
  end
end
