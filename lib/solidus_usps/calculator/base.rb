module SolidusUsps
  module Calculator
    class Base < Spree::ShippingCalculator
      # The rate to charge when USPS can't give us one. When this is blank the
      # shipping method is not offered at all instead. Zero is a valid rate,
      # and means free shipping.
      preference :fallback_rate, :decimal

      # Solidus converts a blank decimal preference to zero, which would turn
      # a fallback rate left empty in the admin into free shipping.
      prepend(Module.new do
        def preferred_fallback_rate=(value)
          super(value.presence)
        end
      end)

      def compute_package(package)
        client.get_rates(rates_search_data(package))["totalBasePrice"]
      rescue SolidusUsps::Errors::ApiError
        preferred_fallback_rate
      end

      def available?(package)
        package.weight > 0
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

