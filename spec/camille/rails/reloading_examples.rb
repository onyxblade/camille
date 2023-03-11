RSpec.shared_examples 'reloading' do
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

  it 'eagerly pickup changes in types and schemas' do
    loaded_types_size = Camille::Loader.loaded_types.size
    loaded_schemas_size = Camille::Loader.loaded_schemas.size

    expect(Camille::Types::Product.new.underlying).not_to be_an_instance_of(Camille::Types::Number)
    expect(Camille::Schemas::Products.endpoints[:data].response_type).not_to be_an_instance_of(Camille::Types::Boolean)

    rewrite_file "#{Rails.root}/config/camille/types/product.rb", product_type_content do
      rewrite_file "#{Rails.root}/config/camille/schemas/products.rb", products_schema_content do
        do_reload

        expect(Camille::Loader.loaded_types.size).to eq(loaded_types_size)
        expect(Camille::Loader.loaded_schemas.size).to eq(loaded_schemas_size)

        expect(Camille::Types::Product.new.underlying).to be_an_instance_of(Camille::Types::Number)
        expect(Camille::Schemas::Products.endpoints[:data].response_type).to be_an_instance_of(Camille::Types::Boolean)

        expect(Camille::Loader.loaded_types).to include(Camille::Types::Product)
        expect(Camille::Loader.loaded_schemas).to include(Camille::Schemas::Products)

        expect(Camille::Loader.loaded_types.size).to eq(loaded_types_size)
        expect(Camille::Loader.loaded_schemas.size).to eq(loaded_schemas_size)
      end
    end
  end

  it 'reconstruct Loader.controller_name_to_schema_map' do
    old_map = Camille::Loader.controller_name_to_schema_map.dup

    rewrite_file "#{Rails.root}/config/camille/schemas/products.rb", products_schema_content do
      do_reload

      expect(Camille::Schemas::Products.endpoints[:data].response_type).to be_an_instance_of(Camille::Types::Boolean)

      expect(Camille::Loader.controller_name_to_schema_map['ProductsController']).to be(Camille::Schemas::Products)
      expect(Camille::Loader.controller_name_to_schema_map['Nested::ProductsController']).to be(Camille::Schemas::Nested::Products)

      expect(Camille::Loader.controller_name_to_schema_map.size).to eq(old_map.size)

      ['ProductsController', 'Nested::ProductsController'].each do |controller_name|
        old_schema = old_map[controller_name]
        new_schema = Camille::Loader.controller_name_to_schema_map[controller_name]
        expect(new_schema.object_id).not_to eq(old_schema.object_id)
      end
    end
  end

  it 'updates routes' do
    rewrite_file "#{Rails.root}/config/camille/schemas/products.rb", products_schema_content do
      do_reload

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

  it 'reloads configurations' do
    random_string = rand.to_s

    configuration = <<~EOF
      Camille.configure do |config|
        config.ts_header = '#{random_string}'
      end
    EOF

    rewrite_file "#{Rails.root}/config/camille/configuration.rb", configuration do
      do_reload
      expect(Camille::CodeGenerator.generate_ts.lines[1].chomp).to eq(random_string)
    end
  end

end