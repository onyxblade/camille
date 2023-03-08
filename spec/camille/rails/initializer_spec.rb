require 'rails_helper'

RSpec.describe 'initializer' do
  it 'eager_loads types and schemas' do
    # comparing to make sure that eager_load instead of autoload happened
    loaded_types_size = Camille::Types.loaded_types.size
    loaded_schemas_size = Camille::Schemas.loaded_schemas.size

    expect(Camille::Types::Product).to be_truthy
    expect(Camille::Types::Nested::Product).to be_truthy
    expect(Camille::Schemas::Products).to be_truthy
    expect(Camille::Schemas::Nested::Products).to be_truthy

    expect(Camille::Types.loaded_types).to include(Camille::Types::Product, Camille::Types::Nested::Product)
    expect(Camille::Schemas.loaded_schemas).to include(Camille::Schemas::Products, Camille::Schemas::Nested::Products)

    expect(Camille::Types.loaded_types.size).to eq(loaded_types_size)
    expect(Camille::Schemas.loaded_schemas.size).to eq(loaded_schemas_size)
  end

  it 'installs controller extension by schemas' do
    expect(ProductsController.included_modules).to include(Camille::ControllerExtension)
    expect(Nested::ProductsController.included_modules).to include(Camille::ControllerExtension)
    expect(Camille::Schemas.controller_schema_map[ProductsController]).to be(Camille::Schemas::Products)
    expect(Camille::Schemas.controller_schema_map[Nested::ProductsController]).to be(Camille::Schemas::Nested::Products)
  end

  it 'loads routes' do
    expect(Rails.application.routes.recognize_path('/products/data', method: :get)).to eq(
      controller: 'products',
      action: 'data'
    )
    expect(Rails.application.routes.recognize_path('/products/update', method: :post)).to eq(
      controller: 'products',
      action: 'update'
    )
    expect(Rails.application.routes.recognize_path('/nested/products/data', method: :get)).to eq(
      controller: 'nested/products',
      action: 'data'
    )
  end

  if Rails.env.development?
    context 'when Rails.env.development?' do
      let(:product_type_content){
        <<~EOF
          class Camille::Types::Product < Camille::Type
            alias_of(Number)
          end
        EOF
      }
      let(:products_schema_content){
        <<~EOF
          class Camille::Schemas::Products < Camille::Schema
            get :data do
              response(Boolean)
            end

            get :new_data do
              response(Boolean)
            end
          end
        EOF
      }

      it 'eagerly pickup changes in types and schemas when `reload!` happened' do
        loaded_types_size = Camille::Types.loaded_types.size
        loaded_schemas_size = Camille::Schemas.loaded_schemas.size

        expect(Camille::Types::Product.new.underlying).not_to be_an_instance_of(Camille::Types::Number)
        expect(Camille::Schemas::Products.endpoints[:data].response_type).not_to be_an_instance_of(Camille::Types::Boolean)

        rewrite_file "#{Rails.root}/config/camille/types/product.rb", product_type_content do
          rewrite_file "#{Rails.root}/config/camille/schemas/products.rb", products_schema_content do
            Rails.application.reloader.reload!

            expect(Camille::Types.loaded_types.size).to eq(loaded_types_size)
            expect(Camille::Schemas.loaded_schemas.size).to eq(loaded_schemas_size)

            expect(Camille::Types::Product.new.underlying).to be_an_instance_of(Camille::Types::Number)
            expect(Camille::Schemas::Products.endpoints[:data].response_type).to be_an_instance_of(Camille::Types::Boolean)

            expect(Camille::Types.loaded_types).to include(Camille::Types::Product)
            expect(Camille::Schemas.loaded_schemas).to include(Camille::Schemas::Products)

            expect(Camille::Types.loaded_types.size).to eq(loaded_types_size)
            expect(Camille::Schemas.loaded_schemas.size).to eq(loaded_schemas_size)
          end
        end
      end

      it 'installs controller extension by schemas when `reload!` happened' do
        old_map = Camille::Schemas.controller_schema_map.dup

        rewrite_file "#{Rails.root}/config/camille/schemas/products.rb", products_schema_content do
          Rails.application.reloader.reload!

          expect(Camille::Schemas::Products.endpoints[:data].response_type).to be_an_instance_of(Camille::Types::Boolean)

          expect(ProductsController.included_modules).to include(Camille::ControllerExtension)
          expect(Nested::ProductsController.included_modules).to include(Camille::ControllerExtension)
          expect(Camille::Schemas.controller_schema_map[ProductsController]).to be(Camille::Schemas::Products)
          expect(Camille::Schemas.controller_schema_map[Nested::ProductsController]).to be(Camille::Schemas::Nested::Products)

          expect(Camille::Schemas.controller_schema_map.size).to eq(old_map.size)

          # reloading will load the new schemas and controller classes.
          # need to ensure that `controller_schema_map` contains the latest references.
          Camille::Schemas.controller_schema_map.values.each do |new_schema|
            old_schema = old_map.values.find{|x| x.klass_name == new_schema.klass_name}
            expect(old_schema).to be_truthy
            expect(new_schema.object_id).not_to eq(old_schema.object_id)
          end

          [ProductsController, Nested::ProductsController].each do |new_controller|
            old_controller = old_map.keys.find{|x| x.name == new_controller.name}
            expect(new_controller.object_id).not_to eq(old_controller.object_id)
          end
        end
      end

      it 'updates routes when `reload!` happened' do
        rewrite_file "#{Rails.root}/config/camille/schemas/products.rb", products_schema_content do
          Rails.application.reloader.reload!

          expect(Rails.application.routes.recognize_path('/products/data', method: :get)).to eq(
            controller: 'products',
            action: 'data'
          )
          expect{Rails.application.routes.recognize_path('/products/update', method: :post)}.to raise_error(ActionController::RoutingError)
          expect(Rails.application.routes.recognize_path('/products/new_data', method: :get)).to eq(
            controller: 'products',
            action: 'new_data'
          )
        end
      end

    end

  end
end
