require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::PriorityMail do
  subject(:calculator) { described_class.new }

  let(:stock_location) { create(:stock_location, zipcode: "12345") }
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
    let(:order) { create(:order, ship_address: create(:address, zipcode: "67890")) }
    let(:rates_search_data) { instance_double(SolidusUsps::RatesSearchData) }

    before do
      allow(calculator).to receive(:rates_search_data).and_return(rates_search_data)
      allow(SolidusUsps::DomesticPricesClient).to receive(:get_rates).and_return("some response")
    end

    it "calls DomesticPricesClient with rates search data" do
      calculator.compute_package(spree_package)
      expect(SolidusUsps::DomesticPricesClient).to have_received(:get_rates).with(rates_search_data)
    end
  end

  describe "#available?" do
    context "when shipping to the US" do
      let(:us) { Spree::Country.find_or_create_by(iso: 'US', name: 'United States') }
      let(:order) { create(:order, ship_address: create(:address, country: us)) }

      it "returns true" do
        expect(calculator.available?(spree_package)).to eq true
      end
    end

    context "when shipping internationally" do
      let(:canada) { Spree::Country.find_or_create_by(iso: 'CA', name: 'Canada') }
      let(:order) { create(:order, ship_address: create(:address, country: canada)) }

      context "when package weight is 4 or less" do
        let(:variant) { create(:variant, weight: 4.0) }

        it "returns false" do
          expect(calculator.available?(spree_package)).to be false
        end
      end

      context "when package weight is more than 4" do
        let(:variant) { create(:variant, weight: 5.0) }

        it "returns true" do
          expect(calculator.available?(spree_package)).to be true
        end
      end
    end
  end
end
