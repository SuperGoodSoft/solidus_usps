module SolidusUsps
  module Calculator
    class FirstClassPackageInternationalWithInsurance < FirstClassPackageInternational
      include SolidusUsps::Calculator::Concerns::WithInsurance
    end
  end
end
