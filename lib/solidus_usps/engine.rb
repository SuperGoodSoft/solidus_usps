# frozen_string_literal: true

require 'solidus_core'
require 'solidus_support'

module SolidusUsps
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace ::Spree

    engine_name 'solidus_usps'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    config.after_initialize do
      require 'solidus_usps/calculator/base'
      require 'solidus_usps/calculator/first_class_package_international'
      require 'solidus_usps/calculator/ground_advantage'
      require 'solidus_usps/calculator/priority_mail'
      require 'solidus_usps/calculator/priority_mail_with_insurance'
    end
  end
end
