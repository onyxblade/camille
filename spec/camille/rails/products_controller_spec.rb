require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'action' do
    context 'when #camille_endpoint not nil' do
      it 'renders camelized keys' do
        get :data
        expect(response.parsed_body).to eq(
          'product' => {
            'id' => 1,
            'name' => 's',
            'availableStock' => 1
          }
        )
      end

      it 'typechecks the response' do
        expect{ get :wrong_data }.to raise_error(Camille::ControllerExtension::TypeError)
      end

      it 'transforms params keys' do
        post :update, params: {
          id: 1,
          product: {
            name: 'string',
            availableStock: 1
          }
        }, as: :json
        expect(response.parsed_body).to include(
          'id' => 1,
          'product' => {
            'name' => 'string',
            'available_stock' => 1
          }
        )
      end
    end

    context 'when #camille_endpoint is nil' do
      it 'does not camelize keys' do
        post :non_camille_action, params: {
          underscore_param: 1
        }, as: :json

        expect(response.parsed_body['underscore_param']).to eq(1)
      end
    end
  end
end