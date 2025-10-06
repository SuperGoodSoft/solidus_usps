module SolidusUsps
  class BasePricesClient
    attr_reader :oauth_client

    def initialize(oauth_client: SolidusUsps::OauthClient.new)
      @oauth_client = oauth_client
    end

    def get_rates(rates_search_data)
      response = connection.post(endpoint, rates_search_data.to_json)

      handle_response(response)
    end

    private

    def connection
      @connection ||= Faraday.new(
        headers: {
          "Authorization" => "Bearer #{oauth_client.access_token}",
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        },
        url: SolidusUsps.configuration.base_url
      ) do |faraday|
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
