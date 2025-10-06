# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class PriorityMail < SolidusUsps::Calculator::Base
      def compute_package(package)
        client = SolidusUsps::DomesticPricesClient.new
        client.get_rates(rates_search_data(package))
      end

      def available? package
        ship_to_country_code(package) == 'US' || package.weight > 4
      end

      def mail_class
        "PRIORITY_MAIL"
      end

      def rate_indicator
        # From the USPS API docs:
        # SP - Single Piece
        "SP"
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


