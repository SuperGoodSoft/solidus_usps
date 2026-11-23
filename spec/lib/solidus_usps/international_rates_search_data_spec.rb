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
        'weight' => 15.0,
        'length' => 6.0,
        'width' => 4.0,
        'height' => 0.25,
        'mailClass' => 'FIRST-CLASS_PACKAGE_INTERNATIONAL_SERVICE',
        'processingCategory' => 'NONSTANDARD',
        'rateIndicator' => "SP",
        'destinationEntryFacilityType' => 'NONE',
        'priceType' => "RETAIL",
        'mailingDate' => Date.tomorrow.to_s,
        'destinationCountryCode' => "CA"
      }.to_json)
    end

    context "when the variant has dimensions" do
      let(:variant) { create(:variant, weight: 10.0, height: 12.5, width: 0.5, depth: 12.5) }

      it "sends the package's dimensions" do
        expect(JSON.parse(subject.to_json)).to include(
          "length" => 12.5,
          "width" => 12.5,
          "height" => 0.5
        )
      end
    end

    context "when it's for priority mail express" do
      let(:calculator) { SolidusUsps::Calculator::PriorityMailExpressInternational.new }

      it "returns PA for the rate indicator" do
        expect(JSON.parse(subject.to_json)).to include(
          "rateIndicator" => "PA"
        )
      end
    end
  end
end
