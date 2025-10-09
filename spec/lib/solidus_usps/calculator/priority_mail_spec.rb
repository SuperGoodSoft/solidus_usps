require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::PriorityMail do
  subject(:calculator) { described_class.new }

  let(:stock_location) { create(:stock_location) }
  let(:variant) { create(:variant, weight: 2.0) }
  let(:line_item) { create(:line_item, order: order, variant: variant, quantity: 1) }
  let(:inventory_unit) {
    create(:inventory_unit, line_item: line_item, order: order, variant: variant)
  }
  let(:spree_package) do
    build(:stock_package, stock_location: stock_location).tap do |package|
      package.add(inventory_unit)
    end
  end

  describe "#compute_package" do
    let(:order) { create(:order, ship_address: create(:address)) }
    let(:client) { instance_double(SolidusUsps::DomesticPricesClient) }

    before do
      allow(SolidusUsps::DomesticPricesClient).to receive(:new).and_return(client)

      allow(client).to receive(:get_rates).and_return("some response")
    end

    it "calls DomesticPricesClient with rates search data" do
      calculator.compute_package(spree_package)
      expect(SolidusUsps::DomesticPricesClient).to have_received(:new)

      expect(client).to have_received(:get_rates)
    end
  end

  describe "#available?" do
    context "when shipping to the US" do
      context "when the poackage is above weight 4" do
        let(:order) { create(:order, ship_address: create(:address)) }
        let(:variant) { create(:variant, weight: 5.0) }

        it "returns true" do
          expect(calculator.available?(spree_package)).to be true
        end
      end
    end

    context "when shipping internationally" do
      let(:order) { create(:order, ship_address: create(:address, country: create(:country, iso: 'CA'))) }
      let(:variant) { create(:variant, weight: 5.0) }

      it "returns false" do
        expect(calculator.available?(spree_package)).to be false
      end
    end
  end
end
