module SolidusUsps
  module Calculator
    class Base < Spree::ShippingCalculator
      def rates_search_data(spree_package)
        SolidusUsps::RatesSearchData.new(spree_package)
      end
    end
  end
end

