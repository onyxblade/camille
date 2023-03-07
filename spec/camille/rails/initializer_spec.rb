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

  if Rails.env.development?

    it 'eagerly pickup changes in types and schemas when `reload!` happened' do
      loaded_types_size = Camille::Types.loaded_types.size
      loaded_schemas_size = Camille::Schemas.loaded_schemas.size

      product_type_content = <<~EOF
        class Camille::Types::Product < Camille::Type
          alias_of(Number)
        end
      EOF

      products_schema_content = <<~EOF
        class Camille::Schemas::Products < Camille::Schema
          get :data do
            response(Boolean)
          end
        end
      EOF

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

  end
end
