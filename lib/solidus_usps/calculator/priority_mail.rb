# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class PriorityMail < SolidusUsps::Calculator::Base
      def compute_package(package)
        data = rates_search_data(package)
        client = SolidusUsps::DomesticPricesClient.new(
          oauth_client: SolidusUsps::OauthClient.new
        )
        client.get_rates(data)
      end

      def available? package
        ship_to_country_code(package) == 'US' || package.weight > 4
      end

      def mail_class
        "PRIORITY_MAIL"
      end

      private

      def ship_to_country_code(package)
        package.order.ship_address.country.iso
      end

      def search_data_class
        SolidusUsps::DomesticRatesSearchData
      end
    end
  end
end


