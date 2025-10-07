# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class MediaMail < SolidusUsps::Calculator::Base
      CATEGORY_NAME = "Media Mail"

      def compute_package(package)
        client = SolidusUsps::DomesticPricesClient.new
        client.get_rates(rates_search_data(package))
      end

      def available?(package)
        package.contents.all? do |item|
          shipping_category_name(item) == CATEGORY_NAME
        end
      end

      def mail_class
        "MEDIA_MAIL"
      end

      private

      def shipping_category_name(item)
        item.variant.product.shipping_category&.name
      end

      def search_data_class
        SolidusUsps::DomesticRatesSearchData
      end
    end
  end
end
