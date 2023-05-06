require 'rails_helper'

RSpec.describe 'initializer' do
  it 'eager_loads types and schemas' do
    # comparing to make sure that eager_load instead of autoload happened
    loaded_types_size = Camille::Loader.loaded_types.size
    loaded_schemas_size = Camille::Loader.loaded_schemas.size

    expect(Camille::Types::Product).to be_truthy
    expect(Camille::Types::Nested::Product).to be_truthy
    expect(Camille::Schemas::Products).to be_truthy
    expect(Camille::Schemas::Nested::Products).to be_truthy

    expect(Camille::Loader.loaded_types).to include(Camille::Types::Product, Camille::Types::Nested::Product)
    expect(Camille::Loader.loaded_schemas).to include(Camille::Schemas::Products, Camille::Schemas::Nested::Products)

    expect(Camille::Loader.loaded_types.size).to eq(loaded_types_size)
    expect(Camille::Loader.loaded_schemas.size).to eq(loaded_schemas_size)
  end

  it 'installs controller extension to base controller' do
    expect(ActionController::Base.included_modules).to include(Camille::Controller)
    expect(ActionController::API.included_modules).to include(Camille::Controller)
  end

  it 'constructs Loader.controller_name_to_schema_map' do
    expect(Camille::Loader.controller_name_to_schema_map['ProductsController']).to be(Camille::Schemas::Products)
    expect(Camille::Loader.controller_name_to_schema_map['Nested::ProductsController']).to be(Camille::Schemas::Nested::Products)
  end

  it 'loads configurations' do
    expect(Camille::Configuration.ts_location).to eq("#{Rails.root}/tmp/api.ts")
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

  it 'adds route for `/camille/endpoints.ts` when Rails.env.development?' do
    if Rails.env.development?
      expect(Rails.application.routes.recognize_path('/camille/endpoints.ts', method: :get)).to eq(
        controller: 'camille/main',
        action: 'endpoints_ts'
      )
    else
      expect{Rails.application.routes.recognize_path('/camille/endpoints.ts', method: :get)}.to raise_error(ActionController::RoutingError)
    end
  end

end
