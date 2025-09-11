module SolidusUsps
  class RatesSearchData
    def initialize(spree_address, spree_shipment)
      @spree_ship_address = spree_address
      @spree_shipment = spree_shipment
      @shipping_method = spree_shipment.shipping_method
    end

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

    private

    def origin_zipcode
      @spree_shipment.stock_location.zipcode
    end

    def weight
      @spree_shipment.line_items.sum do |item|
        weight = item.variant.weight || 0
        weight * item.quantity
      end
    end

    def mail_class
      # TODO: Figure out what the best default/fallback is here.
      @shipping_method.try(:service_level) || 'STANDARD'
    end
  end
end
