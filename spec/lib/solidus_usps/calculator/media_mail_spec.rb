require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::MediaMail do
  subject(:calculator) { described_class.new }

  let(:stock_location) { create(:stock_location) }
  let(:variant) { create(:variant, weight: 1) }
  let(:line_item) { create(:line_item, order: order, variant: variant, quantity: 1) }
  let(:inventory_unit) {
    create(:inventory_unit, line_item: line_item, order: order, variant: variant)
  }
  let(:order) { create(:order, ship_address: create(:address)) }
  let(:package) do
    build(:stock_package, stock_location: stock_location).tap do |package|
      package.add(inventory_unit)
    end
  end

  describe "#compute_package" do
    let(:client) { instance_double(SolidusUsps::DomesticPricesClient) }

    before do
      allow(SolidusUsps::DomesticPricesClient).to receive(:new).and_return(client)
      allow(client).to receive(:get_rates).and_return("some response")
    end

    it "calls DomesticPricesClient with rates search data" do
      calculator.compute_package(package)
      expect(client).to have_received(:get_rates)
    end
  end

  describe "#available?" do
    context "when shipping to the US" do
      let(:order) { create(:order, ship_address: create(:address)) }

      it "returns true" do
        expect(calculator.available?(package)).to be true
      end
    end

    context "when shipping internationally" do
      let(:order) { create(:order, ship_address: create(:address, country: create(:country, iso: 'CA'))) }

      it "returns false" do
        expect(calculator.available?(package)).to be false
      end
    end
  end
end
