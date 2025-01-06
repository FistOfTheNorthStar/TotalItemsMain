module Webhooks
  module Shopify
    class OrderController < BaseWebhookController
      def fulfill
        webhook_data = JSON.parse(request.raw_post)
        return head(:ok) unless webhook_data["fulfillment_status"] == "fulfilled"
        return head(:ok) if Order.find_by(shopify_order_id: webhook_data["id"])

        order = Order.new(shopify_order_id: webhook_data["id"])
        product_sku = webhook_data["line_items"].first["sku"]

        email_and_user_id = find_or_create_user(webhook_data)
        quantity = webhook_data["line_items"].sum { |item| item["quantity"] }
        order.assign_attributes(
          quantity:,
          order_status: :fulfilled,
          product_type: product_sku,
          user_id: email_and_user_id[:id],
          order_completed_date: webhook_data["closed_at"]
        )

        if order.save
          SlackNotificationJob.perform_async(
            "Order fulfilled: #{email_and_user_id[:email]}, id #{webhook_data['id']}, " \
              "sku #{product_sku}, q #{quantity}"
          )
          head(:ok)
        else
          head(:unprocessable_entity)
        end
      rescue JSON::ParserError
        head(:bad_request)
      end

      def refund
        data = JSON.parse(request.raw_post)
        Order.find_by!(shopify_order_id: data["id"]).update!(order_status: :refunded)
        SlackNotificationJob.perform_async("Order refunded: #{data['id']}")
        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end

      def cancel
        data = JSON.parse(request.raw_post)
        order = Order.find_by(shopify_order_id: data["id"])
        return unless order.present?
        order.update!(order_status: :cancelled)
        SlackNotificationJob.perform_async("Order cancelled: #{data['id']}")
        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end

      private

      def find_or_create_user(webhook_data)
        email = webhook_data["email"]
        customer = webhook_data["customer"]

        if customer.blank? && email.blank?
          SlackNotificationJob.perform_async("Order fulfilled without a customer and email #{webhook_data['id']}")
          return { id: nil, email: nil }
        end

        if customer.blank?
          user = User.find_by(email:)
          return { id: user.id, email: } if user
          SlackNotificationJob.perform_async("User created without ShopifyID #{email}")
          { id: User.create!(email:).id, email: }
        else
          user = User.find_by(email: customer["email"])

          if user
            user.update(shopify_id: customer["id"].to_s)
            return { id: user.id, email: customer["email"] }
          end

          address = customer["default_address"]
          country_code = address&.dig("country_code") || "NAN"

          user_params = {
            address_1: address&.dig("address1"),
            address_2: address&.dig("address2") || "",
            city: address&.dig("city"),
            country: PhonePrefixes::COUNTRIES[country_code][:code],
            email: customer["email"],
            first_name: address&.dig("first_name"),
            last_name: address&.dig("last_name"),
            phone: address&.dig("phone"),
            phone_prefix: PhonePrefixes::COUNTRIES[country_code][:code],
            state: address&.dig("province"),
            role: address&.dig("company") ? :company : :user,
            company_name: address&.dig("company"),
            shopify_id: customer["id"].to_s
          }

          SlackNotificationJob.perform_async("User created in Shopify: #{customer["email"]}, #{customer["id"]}")
          { id: User.create!(user_params).id, email: customer["email"] }
        end
      end
    end
  end
end
