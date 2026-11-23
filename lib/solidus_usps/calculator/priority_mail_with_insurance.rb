module SolidusUsps
  module Calculator
    class PriorityMailWithInsurance < PriorityMail
      include SolidusUsps::Calculator::Concerns::WithInsurance
    end
  end
end
