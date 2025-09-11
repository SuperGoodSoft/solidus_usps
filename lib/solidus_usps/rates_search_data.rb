module SolidusUsps
  class RatesSearchData
    def initialize(spree_package)
      @spree_package = spree_package
    end

    def to_json
      {
        'originZIPCode' => origin_zipcode,
        'destinationZIPCode' => destination_zipcode,
        'weight' => weight,
        'length' => nil,
        'width' => nil,
        'height' => nil,
        'mailClass' => nil,
        'processingCategory' => nil,
        'rateIndicator' => nil,
        'destinationEntryFacilityType' => nil,
        'priceType' => nil,
        'mailingDate' => nil, # Optional.
        'accountType' => nil, # Optional.
        'accountNumber' => nil, # Optional.
        'hasNonstandardCharacteristics' => nil, # Optional.
      }.to_json
    end

    private

    def origin_zipcode
      @spree_package.stock_location.zipcode
    end

    def destination_zipcode
      @spree_package.order&.ship_address&.zipcode
    end

    def weight
      @spree_package.weight
    end
  end
end
