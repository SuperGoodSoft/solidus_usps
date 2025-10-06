# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class FirstClassPackageInternational < SolidusUsps::Calculator::Base
      def compute_package(package)
        client = SolidusUsps::InternationalPricesClient.new
        client.get_rates(rates_search_data(package))
      end

      def available? package
        ship_to_country_code(package) == 'US' && package.weight <= 4 && super
      end

      def mail_class
        "FIRST-CLASS_PACKAGE_INTERNATIONAL_SERVICE"
      end

      private

      def ship_to_country_code(package)
        package.order.ship_address.country.iso
      end

      def search_data_class
        SolidusUsps::InternationalRatesSearchData
      end
    end
  end
end
