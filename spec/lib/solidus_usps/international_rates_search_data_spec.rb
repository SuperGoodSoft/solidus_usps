require 'spec_helper'

RSpec.describe SolidusUsps::InternationalRatesSearchData do
  subject { described_class.new(calculator, spree_package) }

  let(:stock_location) { create(:stock_location, zipcode: '45678') }
  let(:order) { create(:order, ship_address: address) }
  let(:address) { create :address, country: create(:country, iso: 'CA') }
  let(:variant) { create(:variant, weight: 15.0) }
  let(:line_item) { create(:line_item, order: order, variant: variant, quantity: 1) }
  let(:inventory_unit) { create(
    :inventory_unit,
    line_item: line_item,
    order: order,
    variant: variant
  )}

  let(:calculator) { SolidusUsps::Calculator::FirstClassPackageInternational.new }

  let(:spree_package) do
    build(:stock_package, stock_location: stock_location).tap do |package|
      package.add inventory_unit
    end
  end

  describe '#to_json' do
    it "returns the correct JSON structure and data" do
      expect(subject.to_json).to eq({
        'originZIPCode' => '45678',
        'weight' => "15.0",
        'length' => nil,
        'width' => nil,
        'height' => nil,
        'mailClass' => 'FIRST-CLASS_PACKAGE_INTERNATIONAL_SERVICE',
        'processingCategory' => nil,
        'rateIndicator' => "LE",
        'destinationEntryFacilityType' => nil,
        'priceType' => "RETAIL",
        'mailingDate' => nil,
        'foreignPostalCode' => nil,
        'destinationCountryCode' => "CA",
        'accountType' => nil,
        'accountNumber' => nil,
      }.to_json)
    end
  end
end
