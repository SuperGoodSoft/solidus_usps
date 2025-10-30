require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::Base do
  subject(:calculator) { described_class.new(preferred_fallback_rate: 5.5) }

  describe "#compute_package" do
    let(:client) { instance_double(SolidusUsps::DomesticPricesClient) }
    let(:package) { build(:stock_package) }

    before do
      # Unfortunate stubs, but it helps avoid having to create a subclass to test
      # the base calculator.
      allow(calculator).to receive(:rates_search_data).and_return({})
      allow(calculator).to receive(:client).and_return(client)
    end

    context "when the client returns a successful response" do
      before do
        allow(client).to receive(:get_rates).and_return({
          "totalBasePrice" => 10
        })
      end

      it "returns the rate from the response" do
        expect(calculator.compute_package(package)).to eq 10
      end
    end

    context "when the client raises an error" do
      before do
        allow(client).to receive(:get_rates).and_raise(
          SolidusUsps::Errors::DomesticPricesApiError,
          double(status: 500, body: "")
        )
      end

      it "returns the fallback rate" do
        expect(calculator.compute_package(package)).to eq 5.5
      end
    end
  end
end
