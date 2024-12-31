module Webhooks
  module Shopify
    class OrderController < BaseWebhookController
      def update
        data = JSON.parse(request.raw_post)
        # TODO
        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end
    end
  end
end
