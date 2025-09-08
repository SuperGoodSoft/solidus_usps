# frozen_string_literal: true

require 'spec_helper'
require 'active_support/testing/time_helpers'

RSpec.describe SolidusUsps::OauthClient do
  include ActiveSupport::Testing::TimeHelpers

  subject { described_class.new(config) }

  let(:config) do
    SolidusUsps::Configuration.new.tap do |config|
      config.base_url = 'https://apis.usps.com'
      config.client_id = 'test-client-id'
      config.client_secret = 'test-client-secret'
    end
  end
  let(:connection) { instance_double(Faraday::Connection) }
  let(:response) { instance_double(Faraday::Response, success?: true, body: response_body) }
  let(:response_body) {{'access_token' => 'abc123', 'expires_in' => 3600}}

  before do
    allow(Faraday).to receive(:new).and_yield(connection).and_return(connection)
    allow(connection).to receive(:request)
    allow(connection).to receive(:response)
    allow(connection).to receive(:adapter)
    allow(connection).to receive(:post).and_return(response)
  end

  describe '#access_token' do
    it 'requests a new token' do
      token = subject.access_token

      expect(token).to eq('abc123')
      expect(connection).to have_received(:post).with(
        '/oauth2/v3/token',
        {
          client_id: 'test-client-id',
          client_secret: 'test-client-secret',
          grant_type: 'client_credentials'
        }
      )
    end

    it 'caches the token until expiry' do
      original_token = subject.access_token
      expect(original_token).to eq('abc123')

      second_token = subject.access_token
      expect(second_token).to eq('abc123')

      expect(connection).to have_received(:post).once
    end

    it 'refreshes the token when expired' do
      freeze_time do
        expect(subject.access_token).to eq('abc123')
        expect(connection).to have_received(:post).once

        # 3600 seconds is the expiry time returned from USPS, so we travel
        # further to ensure the token is expired
        travel 3800.seconds

        allow(response).to receive(:body).and_return({ 'access_token' => 'new456', 'expires_in' => 3600 })
        allow(connection).to receive(:post).and_return(response)

        expect(subject.access_token).to eq('new456')
        expect(connection).to have_received(:post).with(
          '/oauth2/v3/token',
          hash_including(
            client_id: 'test-client-id',
            client_secret: 'test-client-secret',
            grant_type: 'client_credentials'
          )
        ).twice
      end
    end

    context 'when the response is unsuccessful' do
      it 'raises an error' do
        allow(response).to receive(:success?).and_return(false)
        allow(response).to receive(:status).and_return(401)
        allow(response).to receive(:body).and_return('Unauthorized')

        expect { subject.access_token }.to raise_error(
          RuntimeError, /USPS OAuth failed: 401 - Unauthorized/
        )
      end
    end

    context 'when the response is missing expires_in' do
      it 'raises an error' do
        allow(response).to receive(:body).and_return({ 'access_token' => 'abc123' })

        expect { subject.access_token }.to raise_error(
          RuntimeError, /Missing expires_in in USPS OAuth response:/
        )
      end
    end

    context 'when the response is missing access_token' do
      it 'raises an error' do
        allow(response).to receive(:body).and_return({ 'expires_in' => 3600 })

        expect { subject.access_token }.to raise_error(
          RuntimeError, /Missing access_token in USPS OAuth response:/
        )
      end
    end
  end
end
