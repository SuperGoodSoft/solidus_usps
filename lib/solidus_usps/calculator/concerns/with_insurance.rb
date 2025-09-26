module SolidusUsps
  module Calculator
    module Concerns
      module WithInsurance
        extend ActiveSupport::Concern

        included do
          preference :rate_tiers, :array, default: []
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
