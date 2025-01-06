module Webhooks
  module Chargebee
    class CustomerService
      def self.map_billing_address(billing_address)
        return {} unless billing_address

        {
          address_1: billing_address[:line1],
          address_2: billing_address[:line2],
          city: billing_address[:city],
          state: billing_address[:state],
          country: map_country_code(billing_address[:country]),
          phone: billing_address[:phone],
          company_name: billing_address[:company]
        }
      end

      def self.map_country_code(code)
        return 0 if code.blank?

        {
          'US' => 1,
          'GB' => 2,
          'FR' => 3,
          # Add more mappings as needed
        }[code] || 0
      end
    end
  end