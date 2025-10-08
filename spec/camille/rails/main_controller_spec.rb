require 'rails_helper'
require_relative 'reloading_examples'

RSpec.describe Camille::MainController, type: :request do
  before(:each) do
    host! 'localhost'
  end

  if Rails.env.development?

    describe 'GET /camille/endpoints.ts' do
      it 'returns generated typescript only when Rails.env.development?' do
        get '/camille/endpoints.ts'
        expect(response.body).to eq(Camille::CodeGenerator.new.generate_ts)
      end

      context 'when camille files are changed' do
        it_behaves_like 'reloading' do
          subject(:do_reload) {
            get '/camille/endpoints.ts'
          }
        end
      end

      it 'raises error from loader' do
        wrong_content = <<~EOF
          class-Camille::Types::Product < Camille::Type
            alias_of(Number)
          end
        EOF

        rewrite_file "#{Rails.root}/config/camille/types/product.rb", wrong_content do
          get '/camille/endpoints.ts'
          expect(response.status).to eq(500)

          # We need an aditional request here because the first loading error would be rescued by Rails.
          # We want to ensure that the error keeps being reported until it's fixed.

          get '/camille/endpoints.ts'
          expect(response.status).to eq(500)
        end

      end
    end

  end
end