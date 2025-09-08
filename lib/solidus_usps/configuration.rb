# frozen_string_literal: true

module SolidusUsps
  class Configuration
    attr_accessor :client_id, :client_secret, :base_url

    DEFAULT_BASE_URL = 'https://apis.usps.com'

    def initialize
      @base_url = DEFAULT_BASE_URL
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    alias config configuration

    def configure
      yield configuration
    end
  end
end
