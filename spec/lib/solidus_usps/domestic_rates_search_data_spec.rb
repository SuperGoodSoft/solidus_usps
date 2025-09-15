require 'spec_helper'

RSpec.describe SolidusUsps::DomesticRatesSearchData do
  subject { described_class.new(spree_address, spree_shipment) }

  let(:spree_address) { create(:address, zipcode: '12345') }
  let(:spree_shipment) do
    create(:shipment, stock_location: create(:stock_location, zipcode: 45678)).tap do |shipment|
      create(:shipping_rate, shipment: shipment, shipping_method: shipping_method, selected: true)
    end
  end
  let(:shipping_method) { create(:shipping_method, service_level: 'PRIORITY') }

  describe '#to_json' do
    it "returns the correct JSON structure and data" do
      expect(subject.to_json).to eq({
        'originZIPCode' => '45678',
        'destinationZIPCode' => '12345',
        'weight' => 0,
        'length' => nil,
        'width' => nil,
        'height' => nil,
        'mailClass' => 'PRIORITY',
        'processingCategory' => nil,
        'rateIndicator' => nil,
        'destinationEntryFacilityType' => nil,
        'priceType' => nil,
        'mailingDate' => nil,
        'accountType' => nil,
        'accountNumber' => nil,
        'hasNonstandardCharacteristics' => nil,
      }.to_json)
    end

    context "when the shipping method has no service level" do
      before do
        spree_shipment.shipping_method.update!(service_level: nil)
      end

      it "defaults the mailClass to 'STANDARD'" do
        json = JSON.parse(subject.to_json)
        expect(json['mailClass']).to eq 'STANDARD'
      end
    end

    context "when the shipment has line items with weights" do
      let(:order) { create(:order) }
      let(:variant) { create(:variant, weight: 2.0) }
      let!(:line_item) { create(:line_item, variant: variant, quantity: 4, order: order) }
      let(:spree_shipment) { order.tap(&:create_proposed_shipments).shipments.first }

        
      it "calculates the total weight correctly" do
        json = JSON.parse(subject.to_json)
        expect(json['weight']).to eq "8.0"
      end
    end

    context "when a variant has no weight" do
      let(:order) { create(:order) }
      let(:variant) { create(:variant, weight: nil) }
      let!(:line_item) { create(:line_item, variant: variant, quantity: 2, order: order) }
      let(:spree_shipment) { order.tap(&:create_proposed_shipments).shipments.first }

      it "treats the weight as zero" do
        json = JSON.parse(subject.to_json)
        expect(json['weight']).to eq "0.0"
      end
    end
  end
end
