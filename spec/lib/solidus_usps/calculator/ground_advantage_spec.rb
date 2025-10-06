require "spec_helper"

RSpec.describe SolidusUsps::Calculator::GroundAdvantage do
  subject(:calculator) { described_class.new }

  let(:order) { create(:order_ready_to_ship, ship_address: shipping_address) }
  let(:shipping_address) { create(:address, country: create(:country, iso: iso)) }
  let(:iso) { 'US' }
  let(:package) { order.shipments.first.to_package }

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
    context "shipping to the US" do
      context "with a package weight of 13 or less" do
        before do
          order.variants.each { |variant| variant.update!(weight: 2) }
        end

        it "is available" do
          expect(calculator.available?(package)).to eq true
        end
      end

      context "with a package weight over 13" do
        before do
          order.variants.each { |variant| variant.update!(weight: 15) }
        end

        it "is unavailable" do
          expect(calculator.available?(package)).to eq false
        end
      end
    end

    context "shipping internationally" do
      let(:iso) { 'CA' }

      it "is unavailable" do
        expect(calculator.available?(package)).to eq false
      end
    end
  end
end
