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

        user = User.find_by(chargebee_customer_id: customer["id"])
        return unless user

        ActiveRecord::Base.transaction do
          user_subscription = user.subscriptions.create!(
            chargebee_id: subscription["id"],
            plan_id: subscription["plan_id"],
            status: subscription["status"],
            current_term_start: Time.at(subscription["current_term_start"]),
            current_term_end: Time.at(subscription["current_term_end"])
          )

          user.update!(subscription_status: "active")

          SubscriptionMailer.subscription_created(user_subscription).deliver_later
          SlackNotifier.notify("#subscriptions", "New subscription created for #{user.email}")
        end
      end

      def handle_subscription_cancelled
        subscription = @content["subscription"]
        user_subscription = Subscription.find_by(chargebee_id: subscription["id"])
        return unless user_subscription

        ActiveRecord::Base.transaction do
          user_subscription.update!(
            status: "cancelled",
            cancelled_at: Time.current,
            cancellation_reason: subscription["cancel_reason"]
          )

          user = user_subscription.user
          user.update!(subscription_status: "cancelled")

          SubscriptionMailer.subscription_cancelled(user_subscription).deliver_later
          SlackNotifier.notify("#subscriptions", "Subscription cancelled for #{user.email}")
        end
      end

      def handle_subscription_deleted
        subscription = @content["subscription"]
        user_subscription = Subscription.find_by(chargebee_id: subscription["id"])
        return unless user_subscription

        ActiveRecord::Base.transaction do
          user = user_subscription.user

          user_subscription.update!(
            status: "deleted",
            deleted_at: Time.current
          )

          user.update!(subscription_status: "none")

          SlackNotifier.notify("#subscriptions", "Subscription deleted for #{user.email}")
        end
      end

      def handle_payment_succeeded
        payment = @content["payment"]
        invoice = @content["invoice"]
        transaction = @content["transaction"]

        ActiveRecord::Base.transaction do
          payment_record = Payment.create!(
            chargebee_payment_id: payment["id"],
            chargebee_invoice_id: invoice["id"],
            chargebee_transaction_id: transaction["id"],
            amount: payment["amount"] / 100.0,
            currency: payment["currency_code"],
            status: "succeeded",
            payment_method: payment["payment_method"],
            paid_at: Time.at(payment["date"])
          )

          if subscription_id = invoice["subscription_id"]
            subscription = Subscription.find_by(chargebee_id: subscription_id)
            subscription&.update!(payment_status: "paid")
          end

          PaymentMailer.payment_receipt(payment_record).deliver_later
        end
      end

      def handle_payment_failed
        payment = @content["payment"]
        invoice = @content["invoice"]
        transaction = @content["transaction"]

        ActiveRecord::Base.transaction do
          payment_record = Payment.create!(
            chargebee_payment_id: payment["id"],
            chargebee_invoice_id: invoice["id"],
            chargebee_transaction_id: transaction["id"],
            amount: payment["amount"] / 100.0,
            currency: payment["currency_code"],
            status: "failed",
            payment_method: payment["payment_method"],
            error_code: transaction["error_code"],
            error_message: transaction["error_message"],
            failed_at: Time.current
          )

          if subscription_id = invoice["subscription_id"]
            subscription = Subscription.find_by(chargebee_id: subscription_id)
            subscription&.update!(payment_status: "failed")
          end

          PaymentMailer.payment_failed(payment_record).deliver_later
          SlackNotifier.notify("#payments", "Payment failed for Invoice #{invoice['id']}: #{transaction['error_message']}")
        end
      end

      def handle_payment_refunded
        payment = @content["payment"]
        invoice = @content["invoice"]
        transaction = @content["transaction"]

        ActiveRecord::Base.transaction do
          refund = Refund.create!(
            payment_id: payment["id"],
            invoice_id: invoice["id"],
            amount: transaction["amount"] / 100.0,
            currency: transaction["currency_code"],
            reason: transaction["refund_reason"],
            refunded_at: Time.current
          )

          original_payment = Payment.find_by(chargebee_payment_id: payment["id"])
          original_payment&.update!(refunded_at: Time.current, refund_amount: refund.amount)

          RefundMailer.refund_processed(refund).deliver_later
          SlackNotifier.notify("#payments", "Refund processed for Invoice #{invoice['id']}: #{refund.amount} #{refund.currency}")
        end
      end
      def self.map_billing_address(billing_address)
        return {} unless billing_address

        {
          address_1: billing_address[:line1],
          address_2: billing_address[:line2],
          city: billing_address[:city],
          state: billing_address[:state],
          country: map_country_code(billing_address[:country]),
          phone: billing_address[:phone],
          company_name: billing_address[:company]
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