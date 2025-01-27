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
        check_for_coupons(@content)
        user = User.find_by(email: customer["email"])
        p("Here is USER #{user}")
        if user
          user.chargebee_id = customer["id"]
          user.save
          SlackNotificationJob.perform_async("User exists but chargebee_id created or updated: #{customer["email"]}")
        else
          subscription_metadata = subscription["metadata"]
          address = customer["billing_address"]
          country_code = address&.dig("country")
          user_params = {
            email: customer["email"],
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

          User.create!(user_params.merge(chargebee_id: customer["id"].to_s))
          SlackNotificationJob.perform_async("User created a subscription in ChargeBee: #{customer['email']}")
        end
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

      def check_for_coupons(data)
        coupon_metadata = data.dig("subscription", "coupons", 0, "metadata")

        if coupon_metadata
          # Extract any keys you need within the coupon metadata
          tree_credits = coupon_metadata["tree_credits"]
          tree_type    = coupon_metadata["tree_type"]

          puts("Coupon Metadata:")
          puts("- tree_credits: #{tree_credits}")
          puts("- tree_type:    #{tree_type}")
        else
          puts("Coupon Metadata NOT PRESENT")
        end
      end
    end
  end
end
