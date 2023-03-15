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
        expect(response.body).to eq(Camille::CodeGenerator.generate_ts)
      end

      context 'when camille files are changed' do
        it_behaves_like 'reloading' do
          subject(:do_reload) {
            get '/camille/endpoints.ts'
          }
        end
      end
    end

  end
end