require 'rails_helper'
require_relative 'reloading_examples'

RSpec.describe Camille::MainController, type: :request do
  before(:each) do
    host! 'localhost'
  end

  describe 'GET /camille/endpoints.ts' do
    it 'returns generated typescript only when Rails.env.development?' do
      get '/camille/endpoints.ts'

      if Rails.env.development?
        expect(response.body).to eq(Camille::CodeGenerator.generate_ts)
      else
        expect(response.status).to eq(404)
        expect(response.body).to eq('')
      end
    end

    if Rails.env.development?
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