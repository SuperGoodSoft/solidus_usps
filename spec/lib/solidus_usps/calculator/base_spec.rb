require 'spec_helper'

RSpec.describe SolidusUsps::Calculator::Base do
  subject(:calculator) { described_class.new(preferred_fallback_rate: fallback_rate) }

  let(:fallback_rate) { 5.5 }

  describe "#compute_package" do
    let(:client) { instance_double(SolidusUsps::DomesticPricesClient) }
    let(:package) { build(:stock_package) }
    let(:error_handler) { instance_double(Proc, call: nil) }

    before do
      allow(SolidusUsps.configuration).to receive(:error_handler).and_return(error_handler)

      # Unfortunate stubs, but it helps avoid having to create a subclass to test
      # the base calculator.
      allow(calculator).to receive(:rates_search_data).and_return({})
      allow(calculator).to receive(:client).and_return(client)
      allow(calculator).to receive(:mail_class).and_return("SOME_MAIL_CLASS")
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

      it "doesn't report an error" do
        calculator.compute_package(package)

        expect(error_handler).not_to have_received(:call)
      end
    end

    context "when the client raises an error" do
      let(:error) do
        SolidusUsps::Errors::DomesticPricesApiError.new(double(status: 500, body: ""))
      end

      before do
        allow(client).to receive(:get_rates).and_raise(error)
      end

      it "returns the fallback rate" do
        expect(calculator.compute_package(package)).to eq 5.5
      end

      it "reports the error" do
        calculator.compute_package(package)

        expect(error_handler).to have_received(:call).with(
          error,
          hash_including(
            calculator: "SolidusUsps::Calculator::Base",
            mail_class: "SOME_MAIL_CLASS",
            fallback_rate: 5.5
          )
        )
      end

      context "when the fallback rate is zero" do
        let(:fallback_rate) { 0 }

        it "returns zero" do
          expect(calculator.compute_package(package)).to eq 0
        end
      end

      context "when the fallback rate was saved blank" do
        let(:fallback_rate) { "" }

        it "returns no rate, rather than free shipping" do
          expect(calculator.compute_package(package)).to be_nil
        end

        it "reports the error" do
          calculator.compute_package(package)

          expect(error_handler).to have_received(:call).with(error, hash_including(fallback_rate: nil))
        end
      end

      context "when the fallback rate isn't set" do
        let(:fallback_rate) { nil }

        it "returns no rate" do
          expect(calculator.compute_package(package)).to be_nil
        end
      end

      context "when no error handler is configured" do
        let(:error_handler) { nil }

        it "returns the fallback rate" do
          expect(calculator.compute_package(package)).to eq 5.5
        end
      end
    end

    context "when USPS can't be reached" do
      before do
        allow(client).to receive(:get_rates).and_raise(Faraday::ConnectionFailed, "execution expired")
      end

      it "returns the fallback rate" do
        expect(calculator.compute_package(package)).to eq 5.5
      end

      it "reports the error" do
        calculator.compute_package(package)

        expect(error_handler).to have_received(:call).with(
          an_instance_of(Faraday::ConnectionFailed),
          an_instance_of(Hash)
        )
      end
    end
  end
end
