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

      def check_for_coupons(data, user)
        return unless data["subscription"] && data["subscription"]["coupons"].present?

        coupon = data["subscription"]["coupons"].first
        return unless coupon && coupon["metadata"]

        tree_credits = coupon["metadata"]["tree_credits"]
        tree_type = coupon["metadata"]["tree_type"]

        create_coupon_order(user, tree_credits, tree_type)
      end

      def handle_subscription_created
        subscription = @content["subscription"]
        customer = @content["customer"]
        email = customer["email"]
        user = User.find_by(email:)
        if user
          user.chargebee_id = customer["id"]
          user.save
          SlackNotificationJob.perform_async("User exists but chargebee_id created or updated: #{email}")
        else
          subscription_metadata = subscription["metadata"]
          address = customer["billing_address"]
          country_code = address&.dig("country")
          user_params = {
            email:,
            address_1:   address&.dig("line1"),
            address_2: "",
            city:        address&.dig("city"),
            state:       address&.dig("state"),
            country:     country_code ? PhonePrefixes::COUNTRIES[country_code][:code] : nil,  # Or map to your internal code if you wish
            first_name:  address&.dig("first_name"),
            last_name:   address&.dig("last_name"),
            phone:       address&.dig("phone"),
            phone_prefix: country_code ? PhonePrefixes::COUNTRIES[country_code][:code] : nil,
            company_name: address&.dig("company") || "",
            subscription_number_of_trees: subscription_metadata&.dig("tree_credits") || 1,
            subscription_tree_type: subscription_metadata&.dig("tree_type")&.to_sym || :yemani,
            subscription_type:  subscription_metadata&.dig("subscription_type") || :regular,
            subscription_status: :active
          }

          user = User.create!(user_params.merge(chargebee_id: customer["id"].to_s))
          SlackNotificationJob.perform_async("User created a subscription in ChargeBee: #{email}")
        end
        check_for_coupons(@content, user)
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
        payment = @content["payment"]
        invoice = @content["invoice"]
        transaction = @content["transaction"]
        customer = @content["customer"]

        user = User.find_by!(chargebee_id: customer["id"])

        ActiveRecord::Base.transaction do
          # Create payment record
          payment_record = Payment.create!(
            user: user,
            amount: payment["amount"] / 100.0,
            currency: map_currency_code(payment["currency_code"]),
            provider: :chargebee,
            payment_status: :succeeded,
            provider_confirmation_id: payment["id"],
            payment_confirmed_date: Time.at(payment["date"]),
            tax: (payment["tax"] || 0) / 100.0,
            tax_percentage: invoice["tax_percentage"] || 0.0
          )

          # Create order
          product = Product.find_by(chargebee_plan_id: invoice["subscription_id"])

          Order.create!(
            user: user,
            payment: payment_record,
            product: product,
            quantity: 1,
            order_status: :completed,
            product_type: product&.type || 0,
            order_completed_date: Time.current
          )

          PaymentMailer.payment_receipt(payment_record).deliver_later
        end
      end

      def handle_payment_failed
        payment = @content["payment"]
        transaction = @content["transaction"]
        customer = @content["customer"]

        user = User.find_by!(chargebee_id: customer["id"])

        payment_record = Payment.create!(
          user: user,
          amount: payment["amount"] / 100.0,
          currency: map_currency_code(payment["currency_code"]),
          provider: :chargebee,
          payment_status: :failed,
          provider_confirmation_id: payment["id"],
          error_code: transaction["error_code"],
          error: transaction["error_message"]
        )

        PaymentMailer.payment_failed(payment_record).deliver_later
        SlackNotifier.notify("#payments", "Payment failed for #{user.email}: #{transaction['error_message']}")
      end

      def handle_payment_refunded
        payment = @content["payment"]
        transaction = @content["transaction"]
        customer = @content["customer"]

        user = User.find_by!(chargebee_id: customer["id"])
        original_payment = Payment.find_by!(provider_confirmation_id: payment["id"])

        ActiveRecord::Base.transaction do
          original_payment.update!(
            payment_status: :refunded,
            refund_amount: transaction["amount"] / 100.0
          )

          PaymentMailer.refund_processed(original_payment).deliver_later
          SlackNotifier.notify("#payments", "Refund processed for #{user.email}: #{transaction['amount'] / 100.0} #{transaction['currency_code']}")
        end
      end

      private

      def check_for_coupons(data, user)
        coupon_metadata = data.dig("subscription", "coupons", 0, "metadata")

        if coupon_metadata
          tree_credits = coupon_metadata["tree_credits"]
          tree_type    = coupon_metadata["tree_type"]

          order_params={}
          create_coupon_order(order_params, tree_credits, tree_type, user)

          puts("Coupon Metadata:")
          puts("- tree_credits: #{tree_credits}")
          puts("- tree_type:    #{tree_type}")
        end
      end


      def create_coupon_order(order_params, tree_credits, tree_type, user)

        return if Order.find_by(hook_order_id: user.chargebee_id)
        order = Order.new(hook_order_id: user.chargebee_id)
        email_and_user_id = find_or_create_user(webhook_data)

        order.assign_attributes(
          quantity: tree_credits,
          order_status: :fulfilled,
          product_type: "na",
          user_id: user.id,
          order_completed_date: webhook_data["closed_at"],
          tree_type:
        )

        if order.save
          SlackNotificationJob.perform_async(
            "Order fulfilled: #{email_and_user_id[:email]}, id #{webhook_data['id']}, " \
              "sku #{product_sku}, q #{quantity}"
          )
          head(:ok)
        else
          head(:unprocessable_entity)
        end
      rescue JSON::ParserError
        head(:bad_request)
      end





      def create_coupon_order(order_params, email, tree_credits
        webhook_data = JSON.parse(request.raw_post)
        return head(:ok) unless webhook_data["fulfillment_status"] == "fulfilled"
        return head(:ok) if Order.find_by(hook_order_id: webhook_data["id"])

        order = Order.new(hook_order_id: webhook_data["id"])
        product_sku = webhook_data["line_items"].first["sku"]

        tree_type = :no_tree

        if product_sku.present? && VALID_SKUS.include?(product_sku)
          tree_type = :yemani
          order_status = :fulfilled
        else
          order_status = :finished
        end

        quantity = webhook_data["line_items"].sum { |item| item["quantity"] }
        email_and_user_id = find_or_create_user(webhook_data)

        order.assign_attributes(
          quantity:,
          order_status:,
          product_type: product_sku,
          user_id: email_and_user_id[:id],
          order_completed_date: webhook_data["closed_at"],
          tree_type:
        )

        if order.save
          SlackNotificationJob.perform_async(
            "Coupon order created: #{email}, tree creds #{webhook_data['id']}, " \
              "sku #{product_sku}, q #{quantity}"
          )
        else
          SlackNotificationJob.perform_async("Coupon order creation failed: #{email}")
        end
      rescue JSON::ParserError
        head(:bad_request)
      end
    end
  end
end
