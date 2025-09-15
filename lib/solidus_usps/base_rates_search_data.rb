module SolidusUsps
  class BaseRatesSearchData
    def initialize(spree_package)
      @spree_package = spree_package
    end

    private

    def origin_zipcode
      @spree_package.stock_location.zipcode
    end

    def weight
      @spree_package.weight
    end
  end
end
