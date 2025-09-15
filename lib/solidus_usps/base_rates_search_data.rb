module SolidusUsps
  class BaseRatesSearchData
    def initialize(spree_address, spree_shipment)
      @spree_ship_address = spree_address
      @spree_shipment = spree_shipment
      @shipping_method = spree_shipment.shipping_method
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
