module Webhooks
  module Chargebee
    class WebhookController < ApplicationController
      before_action :verify_chargebee_webhook

      def handle
        event = params.permit!.to_h
        event_type = event["event_type"]
        WebhookService.new(event, event_type).process

        head :ok
      rescue => e
        Rails.logger.error("Chargebee Webhook Error: #{e.message}")
        head :unprocessable_entity
      end

      private

      def verify_chargebee_webhook
        head(:ok) unless authenticate # no point in retrying if authenticqtio fails
      end

      def authenticate
        authenticate_or_request_with_http_basic do |username, password|
          ActiveSupport::SecurityUtils.secure_compare(username, CHARGEBEE_WEBHOOK_USERNAME) &
            ActiveSupport::SecurityUtils.secure_compare(password, CHARGEBEE_WEBHOOK_PASSWORD)
        end
      end
    end
  end
end