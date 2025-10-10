# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class MediaMail < SolidusUsps::Calculator::Base
      CATEGORY_NAME = "Media Mail"

      def available?(package)
        package.contents.all? do |item|
          shipping_category_name(item) == CATEGORY_NAME
        end
      end

      def mail_class
        "MEDIA_MAIL"
      end

      private

      def geo_group
        :domestic
      end

      def shipping_category_name(item)
        item.variant.shipping_category&.name
      end
    end
  end
end
