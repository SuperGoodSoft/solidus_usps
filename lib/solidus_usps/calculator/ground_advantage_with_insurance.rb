module SolidusUsps
  module Calculator
    class GroundAdvantageWithInsurance < GroundAdvantage
      include SolidusUsps::Calculator::Concerns::WithInsurance
    end
  end
end
