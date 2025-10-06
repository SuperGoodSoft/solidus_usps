module SolidusUsps
  class InternationalPricesClient < BasePricesClient
    private

    def endpoint
      "/international-prices/v3/base-rates/search"
    end

    def handle_response(response)
      if response.success?
        response.body
      else
        raise SolidusUsps::Errors::InternationalPricesApiError.new(response)
      end
    end
  end
end
