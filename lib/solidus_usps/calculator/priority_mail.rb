# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class PriorityMail < SolidusUsps::Calculator::Base
      def available? package
        ship_to_country_code(package) == 'US' && super
      end

      def mail_class
        "PRIORITY_MAIL"
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
