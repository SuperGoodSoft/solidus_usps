# frozen_string_literal: true

SolidusUsps.configure do |config|
  # config.client_id = ENV["USPS_CLIENT_ID"]
  # config.client_secret = ENV["USPS_CLIENT_SECRET"]

  # Defaults to the production API. Use https://apis-tem.usps.com for testing.
  # config.base_url = "https://apis.usps.com"

  # Called whenever a USPS rate request fails. By default errors are logged
  # and passed to Rails.error.
  # config.error_handler = ->(error, context) { MyErrorTracker.notify(error, context) }

  # The class that works out a package's dimensions, in inches. The default
  # stacks the variants' height/width/depth.
  # config.package_dimensions_class = "SolidusUsps::PackageDimensions"

  # The smallest parcel that will be quoted, as [length, width, height] in
  # inches.
  # config.minimum_package_dimensions = [6, 4, 0.25]
end
