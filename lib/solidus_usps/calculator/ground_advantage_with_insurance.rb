module SolidusUsps
  module Calculator
    class GroundAdvantageWithInsurance < GroundAdvantage
      include SolidusUsps::Calculator::Concerns::WithInsurance

      def compute_package(package)
        super + compute_insurance(package)
      end
    end
  end
end
