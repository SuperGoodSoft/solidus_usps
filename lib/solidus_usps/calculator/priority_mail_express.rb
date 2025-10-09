# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class PriorityMailExpress < SolidusUsps::Calculator::Base
      def available? package
        ship_to_country_code(package) == 'US' && super
      end

      def mail_class
        "PRIORITY_MAIL_EXPRESS"
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
