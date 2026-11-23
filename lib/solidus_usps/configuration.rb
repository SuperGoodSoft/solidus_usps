# frozen_string_literal: true

module SolidusUsps
  class Configuration
    attr_accessor :client_id, :client_secret, :base_url

    # The smallest parcel we will ever quote, as [length, width, height] in
    # inches. USPS rejects rate requests for some mail classes (e.g.
    # First-Class Package International) when the parcel is smaller than
    # 6" x 4", so packages are never reported as smaller than this.
    attr_accessor :minimum_package_dimensions

    attr_writer :package_dimensions_class

    DEFAULT_BASE_URL = 'https://apis.usps.com'
    DEFAULT_MINIMUM_PACKAGE_DIMENSIONS = [6, 4, 0.25].freeze

    def initialize
      @base_url = DEFAULT_BASE_URL
      @minimum_package_dimensions = DEFAULT_MINIMUM_PACKAGE_DIMENSIONS
      @package_dimensions_class = 'SolidusUsps::PackageDimensions'
    end

    # The class used to work out the dimensions of a package. It is
    # initialized with a Spree::Stock::Package and must respond to #length,
    # #width, and #height, returning inches. Accepts a class or a class name.
    def package_dimensions_class
      @package_dimensions_class.to_s.constantize
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
