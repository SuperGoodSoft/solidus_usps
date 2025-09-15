module SolidusUsps
  module Errors
    class ApiError < StandardError
      attr_reader :response

      def initialize(response)
        @response = response
        super("USPS API error: #{response.status} - #{response.body}")
      end
    end

    class DomesticPricesApiError < ApiError; end
    class InternationalPricesApiError < ApiError; end
  end
end
