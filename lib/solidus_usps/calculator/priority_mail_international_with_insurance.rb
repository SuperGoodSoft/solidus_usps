# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class PriorityMailInternationalWithInsurance < PriorityMailInternational
      include SolidusUsps::Calculator::Concerns::WithInsurance

      def compute_package(package)
        super + compute_insurance(package)
      end
    end
  end
end
