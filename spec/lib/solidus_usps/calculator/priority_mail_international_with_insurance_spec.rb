require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::PriorityMailInternationalWithInsurance do
  subject(:calculator) { described_class.new }

  let(:variant) { create(:variant, price: 100) }
  let(:content_item) { double(quantity: 1, variant: variant) }
  let(:spree_package) { double(contents: [content_item]) }

  before do
    allow_any_instance_of(described_class.superclass)
      .to receive(:compute_package).with(spree_package).and_return(20.0)

    allow_any_instance_of(described_class.superclass)
      .to receive(:available?).with(spree_package).and_return(true)
  end

  describe "#compute_package" do
    context "when no rate tiers are configured" do
      it "returns just the base calculator price" do
        expect(calculator.compute_package(spree_package)).to eq(20.0)
      end
    end

    context "when rate tiers are configured" do
      before do
        calculator.preferred_rate_tiers = [
          { 'lower_limit' => '0',   'amount' => '5.0' },
          { 'lower_limit' => '150', 'amount' => '10.0' }
        ]
      end

      it "adds the insurance value to the base rate" do
        expect(calculator.compute_package(spree_package)).to eq(25.0)
      end

      context "when no tiers apply" do
        before do
          calculator.preferred_rate_tiers = [
            { 'lower_limit' => '200', 'amount' => '15.0' }
          ]
        end

        it "returns just the base price" do
          expect(calculator.compute_package(spree_package)).to eq(20.0)
        end
      end
    end
  end
end

