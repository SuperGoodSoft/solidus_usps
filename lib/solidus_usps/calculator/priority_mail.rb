module SolidusUsps
  module Calculator
    class PriorityMail < SolidusUsps::Calculator::Base
      def compute_package(package)
        SolidusUsps::DomesticPricesClient.get_rates(rates_search_data(package))
      end

      def available? package
        ship_to_country_code(package) == 'US' || package.weight > 4
      end

      private

      def ship_to_country_code(package)
        package.order.ship_address.country.iso
      end
    end
  end
end


