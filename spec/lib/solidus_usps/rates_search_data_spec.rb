require 'spec_helper'

RSpec.describe SolidusUsps::RatesSearchData do
  subject { described_class.new(spree_package) }

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

  describe '#to_json' do
    it "returns a JSON string with the correct structure" do
      json_data = JSON.parse(subject.to_json)

      expect(json_data).to include(
        'originZIPCode' => "12345",
        'destinationZIPCode' => "67890",
        'weight' => "10.0",
        'length' => nil,
        'width' => nil,
        'height' => nil,
        'mailClass' => nil,
        'processingCategory' => nil,
        'rateIndicator' => nil,
        'destinationEntryFacilityType' => nil,
        'priceType' => nil,
        'mailingDate' => nil,
        'accountType' => nil,
        'accountNumber' => nil,
        'hasNonstandardCharacteristics' => nil
      )
    end
  end
end
