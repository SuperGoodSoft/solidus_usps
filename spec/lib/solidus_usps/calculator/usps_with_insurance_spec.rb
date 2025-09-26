require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::UspsWithInsurance do
  subject(:calculator) { described_class.new }

  describe "#compute_package" do
    let(:package) { instance_double(Spree::Stock::Package) }
    let(:base_calculator) { instance_double(SolidusUsps::Calculator::PriorityMail) }

    before do
      allow(calculator).to receive(:base_calculator).and_return(base_calculator)
      allow(base_calculator).to receive(:compute_package).and_return(10.0)
      allow(calculator).to receive(:total_value_of_package).with(package).and_return(150.0)
      allow(calculator).to receive(:find_insurance_amount).with(150.0).and_return(5.0)
    end

    it "calculates the total cost including insurance" do
      expect(calculator.compute_package(package)).to eq 15.0
    end
  end
end
