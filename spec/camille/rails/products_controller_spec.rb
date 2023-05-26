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
          expect{ get '/products/wrong_data' }.to raise_error(Camille::Controller::TypeError)
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

      it 'returns the transformed value' do
        get '/products/date_and_decimal'
        expect(response.parsed_body).to include(
          'date' => '1999-12-31',
          'decimal' => 1.2
        )
      end

      it 'returns the transformed value for nested object' do
        get '/products/nested_date_and_decimal'
        expect(response.parsed_body).to include(
          'nested' => {
            'date' => '1999-12-31',
            'decimal' => 1.2
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

      context 'when render call is missing' do
        it 'raises if status is 204' do
          if Rails.env.test?
            expect{ get '/products/missing_render' }.to raise_error(Camille::Controller::MissingRenderError)
          elsif Rails.env.development?
            get '/products/missing_render'
            expect(response.status).to eq(500)
          end
        end

        it 'does not raise if status is not 204' do
          if Rails.env.test?
            expect{ get '/products/head_401' }.not_to raise_error
          elsif Rails.env.development?
            get '/products/head_401'
            expect(response.status).to eq(401)
          end
        end
      end

      context 'when `render` called with a non 200 status code' do
        it 'skips the typecheck' do
          get '/products/render_401'
          expect(response.status).to eq(401)
          expect(response.body).to eq('error')
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