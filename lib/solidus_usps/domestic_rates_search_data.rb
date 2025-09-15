module SolidusUsps
  class DomesticRatesSearchData < BaseRatesSearchData
    def to_json
      {
        'originZIPCode' => origin_zipcode,
        'destinationZIPCode' => @spree_ship_address.zipcode,
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
        'accountType' => nil, # Optional.
        'accountNumber' => nil, # Optional.
        'hasNonstandardCharacteristics' => nil, # Optional.
      }.to_json
    end
  end
end
