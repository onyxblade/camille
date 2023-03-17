require 'rails_helper'

RSpec.describe ProductsController, type: :request do
  before(:each) do
    host! 'localhost'
  end

  describe 'action' do
    context 'when #camille_endpoint not nil' do
      it 'renders camelized keys' do
        get '/products/data'
        expect(response.parsed_body).to eq(
          'product' => {
            'id' => 1,
            'name' => 's',
            'availableStock' => 1
          }
        )
      end

      it 'typechecks the response' do
        # Rails development environment will rescue errors.
        if Rails.env.test?
          expect{ get '/products/wrong_data' }.to raise_error(Camille::ControllerExtension::TypeError)
        elsif Rails.env.development?
          get '/products/wrong_data'
          expect(response.status).to eq(500)
        end
      end

      it 'transforms params keys' do
        post '/products/update', params: {
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

      if Rails.env.development?
        it 'raises error from loader' do
          wrong_content = <<~EOF
            class-Camille::Types::Product < Camille::Type
              alias_of(Number)
            end
          EOF

          rewrite_file "#{Rails.root}/config/camille/types/product.rb", wrong_content do
            get '/products/data'
            expect(response.status).to eq(500)

            # We need an aditional request here because the first loading error would be rescued by Rails.
            # We want to ensure that the error keeps being reported until it's fixed.

            get '/products/data'
            expect(response.status).to eq(500)
          end

        end
      end
    end

    context 'when #camille_endpoint is nil' do
      it 'does not camelize keys' do
        post '/non_camille_action', params: {
          underscore_param: 1
        }, as: :json

        expect(response.parsed_body['underscore_param']).to eq(1)
      end
    end

  end
end