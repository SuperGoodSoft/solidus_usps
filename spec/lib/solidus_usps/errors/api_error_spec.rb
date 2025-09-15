require 'spec_helper'

RSpec.describe SolidusUsps::Errors::ApiError do
  subject { described_class.new(response) }

  let(:response) { double('response', status: 500, body: 'Internal Server Error') }

  describe '#initialize' do
    it 'sets the response' do
      expect(subject.response).to eq(response)
    end

    it 'sets the error message' do
      expect(subject.message).to eq('USPS API error: 500 - Internal Server Error')
    end
  end
end
