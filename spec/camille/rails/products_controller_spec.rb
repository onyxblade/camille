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
        get '/products/wrong_data'
        expect(response.status).to eq(500)
        expect(response.body).to include('Camille::Controller::TypeError')
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

      it 'supports returning false' do
        get '/products/response_false'
        expect(response.parsed_body).to eq(false)
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
          get '/products/missing_render'
          expect(response.status).to eq(500)
          expect(response.body).to include('Camille::Controller::MissingRenderError')
        end

        it 'does not raise if status is not 204' do
          get '/products/head_401'
          expect(response.status).to eq(401)
        end
      end

      context 'when `render` called with a non 200 status code' do
        it 'skips the typecheck' do
          get '/products/render_401'
          expect(response.status).to eq(401)
          expect(response.body).to eq('error')
        end
      end

      context 'when returning records with string keys' do
        it 'does not camelize keys' do
          get '/products/string_records'
          expect(response.parsed_body).to eq({
            'stringRecords' => {
              'long_name' => 1
            }
          })
        end
      end

      context 'when checking params' do
        it 'validates params against the schema' do
          post '/products/update', params: {
            id: 'wrong_type',
            product: {
              name: 'string',
              availableStock: 1
            }
          }, as: :json

          expect(response.status).to eq(500)
          expect(response.body).to include('Type check failed for params')
        end

        it 'accepts valid camelCase params' do
          post '/products/update', params: {
            id: 1,
            product: {
              name: 'string',
              availableStock: 1
            }
          }, as: :json

          expect(response.status).to eq(200)
        end

        it 'validates nested object params' do
          post '/products/update', params: {
            id: 1,
            product: {
              name: 123,  # wrong type
              availableStock: 1
            }
          }, as: :json

          expect(response.status).to eq(500)
          expect(response.body).to include('Type check failed for params')
        end
      end

      context 'when check_params is false' do
        before do
          @original_check_params = Camille::Configuration.check_params
          Camille::Configuration.check_params = false
        end

        after do
          Camille::Configuration.check_params = @original_check_params
        end

        it 'transforms keys without type checking' do
          post '/products/update', params: {
            id: 'wrong_type',  # This would fail type check, but should pass with check_params = false
            product: {
              name: 'string',
              availableStock: 1
            }
          }, as: :json

          expect(response.status).to eq(200)
          expect(response.parsed_body).to include(
            'id' => 'wrong_type',
            'product' => {
              'name' => 'string',
              'available_stock' => 1
            }
          )
        end

        it 'still transforms camelCase to snake_case' do
          post '/products/update', params: {
            id: 1,
            product: {
              name: 'test',
              availableStock: 5
            }
          }, as: :json

          expect(response.status).to eq(200)
          expect(response.parsed_body['product']['available_stock']).to eq(5)
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