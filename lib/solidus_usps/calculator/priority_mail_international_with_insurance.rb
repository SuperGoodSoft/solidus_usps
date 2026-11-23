# frozen_string_literal: true

module SolidusUsps
  module Calculator
    class PriorityMailInternationalWithInsurance < PriorityMailInternational
      include SolidusUsps::Calculator::Concerns::WithInsurance
    end
  end
end
