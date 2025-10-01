require 'spec_helper'

RSpec.describe SolidusUsps::InternationalPricesClient do
  let(:oauth_client) {
    double('OauthClient', access_token: access_token, config: config)
  }
  let(:access_token) { 'test_access_token' }
  let(:config) { double('config', base_url: 'https://apis.usps.com') }
  let(:rates_search_data) { { originZIPCode: '54321', destinationCountryCode: 'CA' } }
  let(:client) { described_class.new(
    oauth_client: oauth_client)
  }
  let(:connection) { instance_double(Faraday::Connection) }

  before do
    allow(Faraday).to receive(:new).and_return(connection)
  end

  context "when the request is successful" do
    let(:success_response) {
      instance_double(
        Faraday::Response,
        success?: true,
        body: { "price" => "5.00" }.to_json,
        status: 200
      )
    }

    before do
      allow(connection).to receive(:post).and_return(success_response)
    end

    it "returns the response body" do
      expect(client.get_rates(rates_search_data))
        .to eq({ "price" => "5.00" })
    end
  end

  context 'when the request is unsuccessful' do
    let(:error_response) {
      instance_double(Faraday::Response, success?: false, body: 'Error message', status: 500)
    }

    before do
      allow(connection).to receive(:post).and_return(error_response)
    end

    it 'raises a DomesticPricesApiError' do
      expect { client.get_rates(rates_search_data) }
        .to raise_error(
          SolidusUsps::Errors::InternationalPricesApiError,
          /USPS API error: 500 - Error message/
        )
    end
  end
end
