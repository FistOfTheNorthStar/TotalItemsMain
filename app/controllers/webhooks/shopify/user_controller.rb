module Webhooks
  module Shopify
    class UserController < BaseWebhookController
      def create
        data = JSON.parse(request.raw_post)
        email = data&.dig("email") || ""
        user = User.find_by(email:)
        if user
          SlackNotificationJob.perform_async("User exists but but shopify_id created or updated: #{data['email']}")
          user.update(shopify_id: data["id"].to_s)
        else
          address = data["default_address"]
          country_code = address&.dig("country_code") || "NAN"
          user_params = {
            address_1: address&.dig("address1"),
            address_2: address&.dig("address2") || "",
            city: address&.dig("city"),
            country: PhonePrefixes::COUNTRIES[country_code][:code],
            email: data["email"],
            first_name: address&.dig("first_name"),
            last_name: address&.dig("last_name"),
            phone: address&.dig("phone"),
            phone_prefix: PhonePrefixes::COUNTRIES[country_code][:code],
            state: address&.dig("province"),
            role: address&.dig("company") ? :company : :user,
            company_name: address&.dig("company")
          }
          SlackNotificationJob.perform_async("User created in Shopify: #{data['email']}")
          User.create!(user_params.merge(shopify_id: data["id"].to_s))
        end

        head(:ok)
      rescue JSON::ParserError => e
        Rails.logger.error(e)
        head(:bad_request)
      rescue StandardError => e
        Rails.logger.error(e)
        head(:unprocessable_entity)
      end

      def deleted
        data = JSON.parse(request.raw_post)
        SlackNotificationJob.perform_async("User deleted ShopifyID: #{data['id']}")
        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end
    end
  end
end
