# frozen_string_literal: true

require 'faraday'

module SolidusUsps
  class OauthClient
    AUTHENTICATION_ENDPOINT = '/oauth2/v3/token'

    def initialize(config = SolidusUsps.configuration)
      @config = config
      @access_token = nil
      @token_expires_at = nil
    end

    def access_token
      return @access_token if token_valid?

      obtain_token
      @access_token
    end

    def base_url
      @config.base_url
    end

    private

    attr_reader :config

    def token_valid?
      @access_token && @token_expires_at && Time.current < @token_expires_at
    end

    def connection
      @connection ||= Faraday.new(url: config.base_url) do |connection|
        connection.request :json
        connection.response :json
        connection.adapter :net_http
      end
    end

    def obtain_token
      response = connection.post(AUTHENTICATION_ENDPOINT, token_request_body)
      return parse_token_response(response.body) if response.success?

      raise "USPS OAuth failed: #{response.status} - #{response.body}"
    end

    def token_request_body
      {
        client_id: config.client_id,
        client_secret: config.client_secret,
        grant_type: 'client_credentials'
      }
    end

    def parse_token_response(body)
      @access_token = body['access_token']
      raise "Missing access_token in USPS OAuth response: #{body.inspect}" unless @access_token

      expires_in = body['expires_in']&.to_i
      raise "Missing expires_in in USPS OAuth response: #{body.inspect}" unless expires_in

      @token_expires_at = Time.current + expires_in.seconds
    end

  end
end
