class ShopifyController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_webhook

  def paid
    webhook_data = JSON.parse(request.body.read)
    ShopifyWebhookJob.perform_later("orders/paid", webhook_data)
    head(:ok)
  rescue => e
    Rails.logger.error("Shopify webhook error: #{e.message}")
    head(:unprocessable_entity)
  end

  def payment_failed
    webhook_data = JSON.parse(request.body.read)
    ShopifyWebhookJob.perform_later("orders/payment_failed", webhook_data)
    head(:ok)
  end

  def customer_created
    webhook_data = JSON.parse(request.body.read)
    ShopifyWebhookJob.perform_later("customers/created", webhook_data)
    head(:ok)
  end

  def refunded
    webhook_data = JSON.parse(request.body.read)
    ShopifyWebhookJob.perform_later("orders/refunded", webhook_data)
    head(:ok)
  end

  private

  def verify_webhook
    data = request.body.read
    hmac = request.headers["X-Shopify-Hmac-Sha256"]

    calculated_hmac = Base64.strict_encode64(
      OpenSSL::HMAC.digest(
        "sha256",
        ENV["SHOPIFY_WEBHOOK_SECRET"],
        data
      )
    )

    unless Rack::Utils.secure_compare(calculated_hmac, hmac)
      head(:unauthorized)
    end

    request.body.rewind
  end
end
