module SolidusUsps
  module Calculator
    class UspsWithInsurance < SolidusUsps::Calculator::Base
      preference :base_calculator_class, :string, default: 'SolidusUsps::Calculator::PriorityMail'
      preference :rate_tiers, :array, default: []

      def compute_package(package)
        base_price = base_calculator.compute_package(package)
        insurance_amount = find_insurance_amount(total_value_of_package(package))
        base_price + insurance_amount
      end

      def available? package
        base_calculator.available?(package)
      end

      private

      def base_calculator
        @base_calculator ||= preferred_base_calculator_class.constantize.new
      end

      def find_insurance_amount(order_value)
        return 0 if preferred_rate_tiers.empty?

        applicable_tiers = preferred_rate_tiers.select do |tier|
          tier['lower_limit'].to_f <= orde_value
        end

        return 0 if applicable_tiers.empty?

        selected_tier = applicable_tiers.max_by { |tier| tier['lower_limit'].to_f }
        selected_tier['amount'].to_f
      end

      def total_value_of_package(package)
        package.contents.sum { |item| item.quantity * item.line_item.price }
      end
    end
  end
end
