module SolidusUsps
  module Calculator
    module Concerns
      module WithInsurance
        extend ActiveSupport::Concern

        included do
          preference :rate_tiers, :array, default: []
        end

        # Insurance is only added when there is a postage rate to add it to.
        # Without one the shipping method isn't offered.
        def compute_package(package)
          base_rate = super
          return if base_rate.nil?

          base_rate + compute_insurance(package)
        end

        def compute_insurance(package)
          package_value = total_value_of_package(package)

          return 0 unless preferred_rate_tiers.present?

          applicable_tiers = preferred_rate_tiers.select do |tier|
            tier['lower_limit'].to_f <= package_value
          end

          return 0 if applicable_tiers.empty?

          selected_tier = applicable_tiers.max_by { |tier| tier['lower_limit'].to_f }
          selected_tier['amount'].to_f
        end

        private

        def total_value_of_package(package)
          package.contents.sum { |content_item| content_item.quantity * content_item.variant.price }
        end
      end
    end
  end
end
