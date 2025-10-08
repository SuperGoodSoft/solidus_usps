require "spec_helper"

RSpec.describe SolidusUsps::Calculator::MediaMailWithInsurance do
  subject(:calculator) { described_class.new }

  let(:variant) { create(:variant, price: 30) }
  let(:content_item) { double(quantity: 1, variant: variant) }
  let(:spree_package) { double(contents: [content_item]) }

  before do
    allow_any_instance_of(described_class.superclass)
      .to receive(:compute_package).with(spree_package).and_return(8.0)

    allow_any_instance_of(described_class.superclass)
      .to receive(:available?).with(spree_package).and_return(true)
  end

  describe "#compute_package" do
    context "when no rate tiers are configured" do
      it "returns just the base calculator price" do
        expect(calculator.compute_package(spree_package)).to eq(8.0)
      end
    end

    context "when rate tiers are configured" do
      before do
        calculator.preferred_rate_tiers = [
          { "lower_limit" => "0",   "amount" => "3.0" },
          { "lower_limit" => "50",  "amount" => "6.0" }
        ]
      end

      it "adds the insurance value to the base rate" do
        expect(calculator.compute_package(spree_package)).to eq(11.0)
      end

      context "when no tiers apply" do
        before do
          calculator.preferred_rate_tiers = [
            { "lower_limit" => "100", "amount" => "12.0" }
          ]
        end

        it "returns just the base price" do
          expect(calculator.compute_package(spree_package)).to eq(8.0)
        end
      end
    end
  end
end
