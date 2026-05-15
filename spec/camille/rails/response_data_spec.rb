require 'rails_helper'
require 'camille/rspec'

RSpec.describe Camille::RSpec::ResponseExtension, type: :request do
  before(:each) do
    host! 'localhost'
  end

  describe 'response.data' do
    it 'returns the snake_case hash validated against the endpoint response type' do
      get '/products/data'
      expect(response.data[:product][:available_stock]).to eq(1)
      expect(response.data['product']['name']).to eq('s')
    end

    it 'preserves non-hash response values (e.g. boolean) as-is' do
      get '/products/response_false'
      expect(response.data).to eq(false)
    end

    it 'raises ResponseTypeError when parsed_body fails type check' do
      get '/products/data'
      allow(response).to receive(:parsed_body).and_return(
        'product' => { 'id' => 'not_a_number', 'name' => 's', 'availableStock' => 1 }
      )
      expect { response.data }.to raise_error(
        Camille::RSpec::ResponseTypeError, /Response type check failed/
      )
    end

    it 'raises MissingEndpointError when the route has no camille endpoint' do
      post '/non_camille_action', params: { underscore_param: 1 }, as: :json
      expect { response.data }.to raise_error(
        Camille::RSpec::MissingEndpointError, /No camille endpoint/
      )
    end
  end
end
