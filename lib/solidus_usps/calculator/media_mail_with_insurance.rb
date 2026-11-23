module SolidusUsps
  module Calculator
    class MediaMailWithInsurance < MediaMail
      include SolidusUsps::Calculator::Concerns::WithInsurance
    end
  end
end
