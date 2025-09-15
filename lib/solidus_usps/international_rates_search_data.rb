module SolidusUsps
  class InternationalRatesSearchData < BaseRatesSearchData
    def to_json
      {
        'originZIPCode' => origin_zipcode,
        'weight' => weight,
        'length' => nil, # TODO: Pull from Spree::ProductPackage?
        'width' => nil, # TODO: Pull from Spree::ProductPackage?
        'height' => nil, # TODO: Pull from Spree::ProductPackage?
        'mailClass' => mail_class,
        'processingCategory' => nil,
        'rateIndicator' => nil,
        'destinationEntryFacilityType' => nil,
        'priceType' => nil,
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
      @spree_ship_address.country.iso
    end
  end
end
