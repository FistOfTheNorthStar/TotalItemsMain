module Webhooks
  module Shopify
    class UserController < BaseWebhookController
      def create
        data = JSON.parse(request.raw_post)
        user = User.find_by(email: data["email"])
        country_code = data["country_code"] || "NAN"

        address = data["default_address"]
        user_params = {
          email: data["email"],
          first_name: data["first_name"],
          last_name: data["last_name"],
          address_1: address["address1"],
          address_2: address["address2"] || "",
          city: address["city"],
          state: address["province"],
          country: CountryPrefixes::COUNTRIES[country_code][:name],
          phone: address["phone"],
          phone_prefix: CountryPrefixes::COUNTRIES[country_code][:prefix],
          salutation: "NAN"
        }
        if user
          user.update(shopify_id: data["id"])
        else
          User.create!(user_params.merge(shopify_id: data["id"]))
        end

        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end






      if user
        user.update(shopify_id: data["id"])
      else
        User.create!(user_params.merge(shopify_id: data["id"]))
      end

      head(:ok)
    rescue StandardError => e
      Rails.logger.error(e)
      head(:unprocessable_entity)

      def delete
        data = JSON.parse(request.raw_post)
        p(data)
        head(:ok)
      rescue JSON::ParserError
        head(:bad_request)
      end
    end
  end
end
