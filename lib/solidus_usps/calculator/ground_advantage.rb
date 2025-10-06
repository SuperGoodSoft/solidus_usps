module SolidusUsps
  module Calculator
    # Originally, FirstClassMailParcel. That service was discontinued in 2023
    # and renamed/merged into USPS Ground Advantage.
    class GroundAdvantage < SolidusUsps::Calculator::Base
      # Maximum weight in ounces. Copied over from the old first class mail
      # parcel so we may need to update this value.
      MAXIMUM_WEIGHT = 13

      def compute_package(package)
        client = SolidusUsps::DomesticPricesClient.new
        client.get_rates(rates_search_data(package))
      end

      def available? package
        ship_to_country_code(package) == 'US' && package.weight <= MAXIMUM_WEIGHT && super
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

      def mail_class
        :USPS_GROUND_ADVANTAGE
      end
    end
  end
end
