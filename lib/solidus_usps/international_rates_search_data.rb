module SolidusUsps
  class InternationalRatesSearchData < BaseRatesSearchData
    def to_json
      {
        'originZIPCode' => origin_zipcode,
        'weight' => weight,
        'length' => nil,
        'width' => nil,
        'height' => nil,
        'mailClass' => mail_class,
        'processingCategory' => nil,
        'rateIndicator' => nil,
        'destinationEntryFacilityType' => nil,
        'priceType' => price_type,
        'mailingDate' => nil, # Optional.
        'foreignPostalCode' => nil, # Optional.
        'destinationCountryCode' => destination_country_code,
        'accountType' => nil, # Optional.
        'accountNumber' => nil, # Optional.
      }.to_json
    end

    private

    # string
    # A 2-digit country code is required for Country of destination.
    def destination_country_code
      @spree_package.order&.ship_address&.country&.iso
    end
  end
end
