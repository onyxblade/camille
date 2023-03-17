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

      it 'sets exception when reloading has error' do
        wrong_content = <<~EOF
          class-Camille::Types::Product < Camille::Type
            alias_of(Number)
          end
        EOF

        rewrite_file "#{Rails.root}/config/camille/types/product.rb", wrong_content do
          expect{Camille::Loader.reload_types_and_schemas}.to raise_error(SyntaxError)
          expect{Camille::Loader.check_and_raise_exception}.to raise_error(SyntaxError)
        end

        expect{Camille::Loader.reload_types_and_schemas}.not_to raise_error
        expect{Camille::Loader.check_and_raise_exception}.not_to raise_error
      end

    end

  end
end
