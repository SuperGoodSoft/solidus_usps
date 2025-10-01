module SolidusUsps
  class BasePricesClient
    attr_reader :oauth_client

    def initialize(oauth_client: SolidusUsps::OauthClient.new)
      @oauth_client = oauth_client
    end

    def get_rates(rates_search_data)
      response = connection.post(endpoint) do |request|
        request.headers["Authorization"] = "Bearer #{@oauth_client.access_token}"
        request.headers['Content-Type'] = 'application/json'
        request.body = rates_search_data.to_json
      end

      handle_response(response)
    end

    private

    def connection
      Faraday.new(url: oauth_client.config.base_url) do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def endpoint
      raise NotImplementedError, 'Subclasses must implement the endpoint method'
    end

    def handle_response(_response)
      raise NotImplementedError, "Subclasses must implement the handle_response method"
    end
  end
end
