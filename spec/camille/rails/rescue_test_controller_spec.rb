require 'rails_helper'

RSpec.describe RescueTestController, type: :request do
  before(:each) do
    host! 'localhost'
  end

  describe 'rescue_from' do
    it 'rescues ParamsTypeError' do
      post '/rescue_test/update', params: {
        id: 'wrong_type'
      }, as: :json

      expect(response.status).to eq(400)
      expect(response.parsed_body['error']).to eq('params_type_error')
    end

    it 'rescues ResponseTypeError' do
      get '/rescue_test/wrong_response'

      expect(response.status).to eq(500)
      expect(response.parsed_body['error']).to eq('response_type_error')
    end
  end
end
