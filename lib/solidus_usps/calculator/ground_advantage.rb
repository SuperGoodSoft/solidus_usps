# frozen_string_literal: true

module SolidusUsps
  module Calculator
    # Originally, FirstClassMailParcel. That service was discontinued in 2023
    # and renamed/merged into USPS Ground Advantage.
    class GroundAdvantage < SolidusUsps::Calculator::Base
      # Maximum weight in ounces. Copied over from the old first class mail
      # parcel so we may need to update this value.
      MAXIMUM_WEIGHT = 13

      def available? package
        ship_to_country_code(package) == 'US' && package.weight <= MAXIMUM_WEIGHT && super
      end

      def mail_class
        "USPS_GROUND_ADVANTAGE"
      end

      private

      def geo_group
        :domestic
      end

      def ship_to_country_code(package)
        package.order.ship_address.country.iso
      end
    end
  end
end
