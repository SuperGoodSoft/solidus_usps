module SolidusUsps
  class DomesticRatesSearchData < BaseRatesSearchData
    def to_json
      {
        'originZIPCode' => origin_zipcode,
        'destinationZIPCode' => destination_zipcode,
        'weight' => weight.to_f,
        'length' => dimensions.length,
        'width' => dimensions.width,
        'height' => dimensions.height,
        'mailClass' => mail_class,
        'processingCategory' => "NONSTANDARD",
        'rateIndicator' => rate_indicator,
        'destinationEntryFacilityType' => "NONE",
        'priceType' => price_type,
        'mailingDate' => Date.tomorrow.to_s
      }.to_json
    end

    private

    # SP - Single Piece
    # PA - Priority Mail Express Single Piece
    def rate_indicator
      mail_class == "PRIORITY_MAIL_EXPRESS" ? "PA" : "SP"
    end

    def destination_zipcode
      @spree_package.order&.ship_address&.zipcode
    end
  end
end
