require "spec_helper"

RSpec.describe SolidusUsps::Calculator::FirstClassPackageInternational do
  subject(:calculator) { described_class.new }

  let(:order) { create(:order_ready_to_ship, ship_address: shipping_address) }
  let(:shipping_address) { create(
    :address,
    country: create(:country, iso: iso))
  }
  let(:iso) { 'US' }
  let(:spree_package) { order.shipments.first.to_package }

  describe "#compute_package" do
    let(:client) { instance_double(SolidusUsps::InternationalPricesClient) }

    before do
      allow(SolidusUsps::InternationalPricesClient).to receive(:new).and_return(client)
      allow(client).to receive(:get_rates).and_return("some response")
    end

    it "calls InternationalPricesClient with rates search data" do
      calculator.compute_package(spree_package)

      expect(SolidusUsps::InternationalPricesClient).to have_received(:new)
      expect(client).to have_received(:get_rates)
    end
  end

  describe "#available?" do
    context "shipping to Canada" do
      let(:iso) { "CA" }

      context "with a package weight of 64 or less" do
        before do
          order.variants.each { |variant| variant.update!(weight: 2) }
        end

        it "is available" do
          expect(calculator.available?(spree_package)).to eq true
        end
      end

      context "with a package weight over 64" do
        before do
          order.variants.each { |variant| variant.update!(weight: 65) }
        end

        it "is unavailable" do
          expect(calculator.available?(spree_package)).to eq false
        end
      end
    end

    context "shipping internationally" do
      let(:iso) { 'US' }

      it "is unavailable" do
        expect(calculator.available?(spree_package)).to eq false
      end
    end
  end
end
