require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'action' do
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
  end
end