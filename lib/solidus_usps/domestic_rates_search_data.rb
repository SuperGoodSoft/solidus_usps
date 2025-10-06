module SolidusUsps
  class DomesticRatesSearchData < BaseRatesSearchData
    def to_json
      {
        'originZIPCode' => origin_zipcode,
        'destinationZIPCode' => destination_zipcode,
        'weight' => weight.to_f,
        'length' => 0, # Carry over from ActiveShipping. We just default to 0, 0, 0 for the dimensions.
        'width' => 0,
        'height' => 0,
        'mailClass' => mail_class,
        'processingCategory' => "NONSTANDARD", # Because we have no dimensions, everything is non-standard.
        'rateIndicator' => rate_indicator,
        'destinationEntryFacilityType' => "NONE",
        'priceType' => price_type
      }.to_json
    end

    private

    def destination_zipcode
      @spree_package.order&.ship_address&.zipcode
    end
  end
end
