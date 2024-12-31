module Webhooks
  module Shopify
    class BaseWebhookController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :verify_shopify_webhook

      private

      def verify_shopify_webhook
        data = request.raw_post
        hmac_header = request.headers["HTTP_X_SHOPIFY_HMAC_SHA256"]
        verified = verify_webhook(data, hmac_header)
        head(:unauthorized) unless verified
      end

      def verify_webhook(data, hmac_header)
        calculated_hmac = Base64.strict_encode64(
          OpenSSL::HMAC.digest("sha256", ENV["SHOPIFY_WEBHOOK_SIGNING_SECRET"], data)
        )
        ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, hmac_header)
      end
    end
  end
end