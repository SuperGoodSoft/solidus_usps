# frozen_string_literal: true

module SolidusUsps
  class InternationalRatesSearchData < BaseRatesSearchData
    def to_json
      {
        'originZIPCode' => origin_zipcode,
        'weight' => weight.to_f,
        'length' => 0, # Carry over from ActiveShipping. We just default to 0, 0, 0 for the dimensions.
        'width' => 0,
        'height' => 0,
        'mailClass' => mail_class,
        'processingCategory' => "NONSTANDARD", # Because we have no dimensions, everything is non-standard.
        'rateIndicator' => rate_indicator,
        'destinationEntryFacilityType' => "NONE",
        'priceType' => price_type,
        'mailingDate' => Date.tomorrow.to_s,
        'destinationCountryCode' => destination_country_code
      }.to_json
    end

    private

    # SP - Single Piece
    # PA - Priority Mail Express Single Piece
    def rate_indicator
      mail_class == "PRIORITY_MAIL_EXPRESS_INTERNATIONAL" ? "PA" : "SP"
    end

    # string
    # A 2-digit country code is required for Country of destination.
    def destination_country_code
      @spree_package.order&.ship_address&.country&.iso
    end
  end
end
