module Webhooks
  module Chargebee
    class UserController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :verify_chargebee_webhook

      def handle
        event_type = params[:event_type]
        customer = params[:content][:customer]

        case event_type
        when "customer_created"
          handle_customer_created(customer)
        when "customer_deleted"
          handle_customer_deleted(customer)
        else
          return head(:bad_request)
        end

        head(:ok)
      rescue StandardError => e
        Rails.logger.error("ChargeBee webhook error: #{e.message}")
        head(:unprocessable_entity)
      end

      private

      def handle_customer_created(customer_data)
        User.create_or_update_from_chargebee(customer_data)
      end

      def handle_customer_deleted(customer_data)
        user = User.find_by(chargebee_id: customer_data[:id])
        user&.update!(deactivated: true)
      end

      def verify_chargebee_webhook
        return head(:unauthorized) unless valid_chargebee_webhook?
      end

      def valid_chargebee_webhook?
        signature = request.headers["X-Chargebee-Signature"]
        return false unless signature.present?

        expected_signature = OpenSSL::HMAC.hexdigest(
          "sha256",
          ENV["CHARGEBEE_WEBHOOK_SECRET"],
          request.raw_post
        )

        ActiveSupport::SecurityUtils.secure_compare(signature, expected_signature)
      end
    end
  end
end