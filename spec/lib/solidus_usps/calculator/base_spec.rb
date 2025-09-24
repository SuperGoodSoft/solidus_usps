require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::Base do
  subject { described_class.new }

  let(:stock_location) { create(:stock_location, zipcode: "12345") }
  let(:order) { create(:order, ship_address: create(:address, zipcode: "67890")) }
  let(:variant) { create(:variant, weight: 10.0) }
  let(:line_item) { create(:line_item, order: order, variant: variant, quantity: 1) }
  let(:inventory_unit) { create(:inventory_unit, line_item: line_item, order: order, variant: variant) }

  let(:spree_package) do
    build(:stock_package, stock_location: stock_location).tap do |package|
      package.add(inventory_unit)
    end
  end

  describe "#rates_search_data" do
    it "returns a SolidusUsps::RatesSearchData object built from the package" do
      result = subject.rates_search_data(spree_package)

      expect(result).to be_a(SolidusUsps::RatesSearchData)
      expect(result.to_json).to include("12345", "67890", "10.0")
    end
  end
end
