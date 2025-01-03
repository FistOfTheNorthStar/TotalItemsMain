module Webhooks
  module Shopify
    class OrderController < BaseWebhookController
      def cancel
        data = JSON.parse(request.raw_post)
        p data
        SlackNotificationJob.perform_async("Order cancelled: #{data['email']}")

        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end

      def fulfill
        data = JSON.parse(request.raw_post)
        p data
        SlackNotificationJob.perform_async("Order fulfilled: #{data['email']}")

        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end

      def refund
        data = JSON.parse(request.raw_post)
        p data
        SlackNotificationJob.perform_async("Order refunded: #{data['email']}")
        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end
    end
  end
end
