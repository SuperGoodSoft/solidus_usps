# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class PriorityMailInternational < SolidusUsps::Calculator::Base
      MINIMUM_WEIGHT = 4

      def available? package
        ship_to_country_code(package) != 'US' && package.weight >= MINIMUM_WEIGHT && super
      end

      def mail_class
        "PRIORITY_MAIL_INTERNATIONAL"
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
