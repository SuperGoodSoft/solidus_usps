# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class FirstClassPackageInternational < SolidusUsps::Calculator::Base
      # Taken from the limit in solidus_active_shipping.
      MAXIMUM_WEIGHT = 64

      def available? package
        ship_to_country_code(package) != 'US' && package.weight <= MAXIMUM_WEIGHT && super
      end

      def mail_class
        "FIRST-CLASS_PACKAGE_INTERNATIONAL_SERVICE"
      end

      private

      def geo_group
        :international
      end

      def ship_to_country_code(package)
        package.order.ship_address.country.iso
      end
    end
  end
end
