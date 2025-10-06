require 'spec_helper'

RSpec.describe SolidusUsps::DomesticRatesSearchData do
  subject { described_class.new(calculator, spree_package) }

  let(:stock_location) { create(:stock_location, zipcode: '45678') }
  let(:order) { create(:order, ship_address: create(:address, zipcode: '12345')) }
  let(:variant) { create(:variant, weight: 10.0) }
  let(:line_item) { create(:line_item, order: order, variant: variant, quantity: 1) }
  let(:inventory_unit) { create(
    :inventory_unit,
    line_item: line_item,
    order: order,
    variant: variant
  )}

  let(:calculator) { SolidusUsps::Calculator::PriorityMail.new }

  let(:spree_package) do
    build(:stock_package, stock_location: stock_location).tap do |package|
      package.add inventory_unit
    end
  end

  describe '#to_json' do
    it "returns the correct JSON structure and data" do
      expect(subject.to_json).to eq({
        'originZIPCode' => '45678',
        'destinationZIPCode' => '12345',
        'weight' => "10.0",
        'length' => nil,
        'width' => nil,
        'height' => nil,
        'mailClass' => 'PRIORITY_MAIL',
        'processingCategory' => nil,
        'rateIndicator' => nil,
        'destinationEntryFacilityType' => nil,
        'priceType' => "RETAIL",
        'mailingDate' => nil,
        'accountType' => nil,
        'accountNumber' => nil,
        'hasNonstandardCharacteristics' => nil,
      }.to_json)
    end
  end
end
