module SolidusUsps
  class BaseRatesSearchData
    def initialize(calculator, spree_package)
      @calculator = calculator
      @spree_package = spree_package
    end

    private

    def mail_class
      @calculator.mail_class
    end

    def origin_zipcode
      @spree_package.stock_location.zipcode
    end

    def price_type
      "RETAIL"
    end

    def weight
      @spree_package.weight
    end
  end
end
