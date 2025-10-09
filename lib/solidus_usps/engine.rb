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
      require 'solidus_usps/calculator/first_class_package_international_with_insurance'
      require 'solidus_usps/calculator/ground_advantage'
      require 'solidus_usps/calculator/ground_advantage_with_insurance'
      require 'solidus_usps/calculator/media_mail'
      require 'solidus_usps/calculator/media_mail_with_insurance'
      require 'solidus_usps/calculator/priority_mail'
      require 'solidus_usps/calculator/priority_mail_with_insurance'
      require 'solidus_usps/calculator/priority_mail_international'
      require 'solidus_usps/calculator/priority_mail_international_with_insurance'
    end

    initializer "solidus_usps.register.calculators", after: "spree.register.calculators" do |app|
      config.to_prepare do
        if app.config.spree.calculators.shipping_methods
          calculator_classes = %w[
            SolidusUsps::Calculator::FirstClassPackageInternational
            SolidusUsps::Calculator::FirstClassPackageInternationalWithInsurance
            SolidusUsps::Calculator::GroundAdvantage
            SolidusUsps::Calculator::GroundAdvantageWithInsurance
            SolidusUsps::Calculator::MediaMail
            SolidusUsps::Calculator::MediaMailWithInsurance
            SolidusUsps::Calculator::PriorityMail
            SolidusUsps::Calculator::PriorityMailWithInsurance
            SolidusUsps::Calculator::PriorityMailInternational
            SolidusUsps::Calculator::PriorityMailInternationalWithInsurance
          ]
          app.config.spree.calculators.shipping_methods.concat calculator_classes
        end
      end
    end
  end
end
