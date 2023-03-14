require 'rails_helper'
require_relative 'reloading_examples'

RSpec.describe 'reloading' do
  if Rails.env.development?

    context 'when Rails.env.development?' do
      after(:each){
        Camille::Loader.reload_types_and_schemas
      }

      describe 'Rails.application.reloader.reload!' do
        it_behaves_like 'reloading' do
          subject(:do_reload) { Rails.application.reloader.reload! }
        end
      end

    end

  end
end
