module Webhooks
  module Chargebee
    class WebhookService
      attr_reader :event, :content

      def initialize(event, content)
        @event = event
        @content = content
      end

      def process
        case @event["event_type"]
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
          Rails.logger.info("Unhandled Chargebee event: #{@event['event_type']}")
        end
      end

      private

      def handle_subscription_created
        subscription = @content["subscription"]
        customer = @content["customer"]
        billing_address = @content["customer"]&.dig("billing_address")

        # Find or create user
        user = User.find_or_initialize_by(chargebee_id: customer["id"])

        subscription_data = extract_subscription_data(subscription)
        user_data = {
          email: customer["email"],
          first_name: customer["first_name"],
          last_name: customer["last_name"]
        }.merge(self.class.map_billing_address(billing_address))
         .merge(subscription_data)

        user.assign_attributes(user_data)
        user.save!

        SlackNotifier.notify("#subscriptions", "New subscription created for #{user.email}")
        #UserMailer.subscription_created(user).deliver_later
      end

      def handle_subscription_cancelled
        customer = @content["customer"]
        user = User.find_by(email: customer["email"])
        return unless user&.chargebee_id

        user.update!( subscription_status: :cancelled)
        SlackNotificationJob.perform_async("Subscription cancelled for #{user.email}")
      end

      def handle_subscription_deleted
        customer = @content["customer"]
        user = User.find_by(email: customer["email"])
        return unless user&.chargebee_id

        user.update!( subscription_status: :deleted)
        SlackNotificationJob.perform_async("Subscription deleted for #{user.email}")
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

      def extract_subscription_data(subscription)
        {
          subscription_tree_type: map_subscription_type(subscription["plan_id"]),
          subscription_renew_date: subscription["current_term_end"],
          subscription_number_of_trees: subscription["plan_quantity"] || 0
        }
      end

      def map_subscription_type(plan_id)
        case plan_id
        when /monthly/i
          1
        when /yearly/i
          2
        else
          0
        end
      end

      def map_currency_code(code)
        return 0 if code.blank?

        {
          'USD' => 1,
          'EUR' => 2,
          'GBP' => 3,
          # Add more mappings as needed
        }[code.upcase] || 0
      end

      def self.map_billing_address(billing_address)
        return {} unless billing_address

        {
          address_1: billing_address["line1"],
          address_2: billing_address["line2"],
          city: billing_address["city"],
          state: billing_address["state"],
          country: map_country_code(billing_address["country"]),
          phone: billing_address["phone"],
          company_name: billing_address["company"]
        }
      end

      def self.map_country_code(code)
        return 0 if code.blank?

        {
          'US' => 1,
          'GB' => 2,
          'FR' => 3,
          # Add more mappings as needed
        }[code] || 0
      end
    end
  end
end