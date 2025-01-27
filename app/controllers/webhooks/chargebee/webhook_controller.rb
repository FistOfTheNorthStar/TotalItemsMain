module Webhooks
  module Chargebee
    class WebhookController < ApplicationController
      skip_forgery_protection
      before_action :verify_chargebee_webhook

      def handle
        event = parse_request_body
        WebhookService.new(event).process
        head(:ok)
      rescue => e
        Rails.logger.error("Chargebee Webhook Error: #{e.message}")
        head(:unprocessable_entity)
      end

      private

      def verify_chargebee_webhook
        unless authenticate
          Rails.logger.warn("Chargebee webhook authentication failed")
          head(:ok) and return # Return OK if authentication fails
        end
      end

      def parse_request_body
        raw_body = request.raw_post
        JSON.parse(raw_body)
      end

      def authenticate
        authenticate_with_http_basic do |username, password|
          is_authenticated = ActiveSupport::SecurityUtils.secure_compare(username, ENV["CHARGEBEE_WEBHOOK_USERNAME"]) &&
            ActiveSupport::SecurityUtils.secure_compare(password, ENV["CHARGEBEE_WEBHOOK_PASSWORD"])
          return true if is_authenticated
        end
        false
      end
    end
  end
end
