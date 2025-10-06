module SolidusUsps
  class DomesticPricesClient < BasePricesClient
    private

    def endpoint
      "/prices/v3/base-rates/search"
    end

    def handle_response(response)
      if response.success?
        response.body
      else
        raise SolidusUsps::Errors::DomesticPricesApiError.new(response)
      end
    end
  end
end
