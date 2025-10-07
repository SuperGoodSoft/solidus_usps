module SolidusUsps
  module Calculator
    class Base < Spree::ShippingCalculator
      def compute_package(package)
        client.get_rates(rates_search_data(package))["totalBasePrice"]
      end

      private

      def client
        case geo_group
        when :international
          SolidusUsps::InternationalPricesClient.new
        when :domestic
          SolidusUsps::DomesticPricesClient.new
        else
          raise "Invalid geo_group"
        end
      end

      def search_data_class
        case geo_group
        when :international
          SolidusUsps::InternationalRatesSearchData
        when :domestic
          SolidusUsps::DomesticRatesSearchData
        else
          raise "Invalid geo_group"
        end
      end

      def rates_search_data(spree_package)
        search_data_class.new(self, spree_package)
      end

      def mail_class
        raise NotImplementedError, "Subclasses must implement the mail_class method"
      end
    end
  end
end

