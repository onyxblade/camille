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
    expect(ActionController::Base.included_modules).to include(Camille::ControllerExtension)
    expect(ActionController::API.included_modules).to include(Camille::ControllerExtension)
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

  if Rails.env.development?
    context 'when Rails.env.development?' do
      after(:each) do
        Camille::Loader.reload
      end

      it 'calls Camille::Loader.reload when `reload!`' do
        last_reload = Camille::Loader.instance_variable_get(:@last_reload)
        Rails.application.reloader.reload!
        new_reload = Camille::Loader.instance_variable_get(:@last_reload)
        expect(new_reload).to be_truthy
        expect(new_reload).not_to eq(last_reload)
      end

    end

  end
end
