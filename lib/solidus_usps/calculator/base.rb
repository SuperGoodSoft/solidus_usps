module SolidusUsps
  module Calculator
    class Base < Spree::ShippingCalculator
      def rates_search_data(spree_package)
        search_data_class.new(self, spree_package)
      end

      private

      def mail_class
        raise NotImplementedError, "Subclasses must implement the mail_class method"
      end

      def search_data_class
        raise NotImplementedError, "Subclasses must implement the search_data_class method"
      end
    end
  end
end

