module SolidusUsps
  class DomesticPricesClient
    class DomestricPricesError < StandardError; end

    DOMESTIC_PRICES_ENDPOINT = "https://apis.usps.com/prices/v3/base-rates/search"

    def initialize(oauth_client = nil)
      @oauth_client = oauth_client || SolidusUsps::OauthClient.new
    end

    def get_rates(rates_search_data)
      response = connection.post(DOMESTIC_PRICES_ENDPOINT) do |request|
        request.headers["Authorization"] = "Bearer #{@oauth_client.access_token}"
        request.headers["Content-Type"] = "application/json"
        request.body = rates_search_data.to_json
      end
      
      return response.body if response.success?

      raise DomestricPricesError, "Error fetching rates: #{response.status} - #{response.body}"
    end

    private

    def connection
      @connection ||= Faraday.new(url: @oauth_client.config.base_url) do |connection|
        connection.request :json
        connection.response :json
        connection.adapter :net_http
      end
    end
  end
end
