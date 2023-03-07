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
end
