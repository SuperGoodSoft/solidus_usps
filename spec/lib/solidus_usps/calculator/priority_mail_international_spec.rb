require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::PriorityMailInternational do
  subject(:calculator) { described_class.new }

  let(:stock_location) { create(:stock_location) }
  let(:variant) { create(:variant, weight: 5.0) }
  let(:line_item) { create(:line_item, order: order, variant: variant, quantity: 1) }
  let(:inventory_unit) {
    create(:inventory_unit, line_item: line_item, order: order, variant: variant)
  }
  let(:spree_package) do
    build(:stock_package, stock_location: stock_location).tap do |package|
      package.add(inventory_unit)
    end
  end

  describe "#available?" do
    context "when shipping to the US" do
      let(:us) { Spree::Country.find_or_create_by(iso: 'US', name: 'United States') }
      let(:order) { create(:order, ship_address: create(:address, country: us)) }

      it "returns false" do
        expect(calculator.available?(spree_package)).to be false
      end
    end

    context "when shipping internationally" do
      let(:canada) { Spree::Country.find_or_create_by(iso: 'CA', name: 'Canada') }
      let(:order) { create(:order, ship_address: create(:address, country: canada)) }

      it "returns true" do
        expect(calculator.available?(spree_package)).to be true
      end
    end
  end
end
