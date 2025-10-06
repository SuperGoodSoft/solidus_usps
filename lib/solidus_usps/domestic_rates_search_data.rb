module SolidusUsps
  class DomesticRatesSearchData < BaseRatesSearchData
    def to_json
      {
        'originZIPCode' => origin_zipcode,
        'destinationZIPCode' => destination_zipcode,
        'weight' => weight,
        'length' => nil,
        'width' => nil,
        'height' => nil,
        'mailClass' => mail_class,
        'processingCategory' => nil,
        'rateIndicator' => rate_indicator,
        'destinationEntryFacilityType' => nil,
        'priceType' => price_type,
        'mailingDate' => nil, # Optional.
        'accountType' => nil, # Optional.
        'accountNumber' => nil, # Optional.
        'hasNonstandardCharacteristics' => nil, # Optional.
      }.to_json
    end

    private

    def destination_zipcode
      @spree_package.order&.ship_address&.zipcode
    end
  end
end
