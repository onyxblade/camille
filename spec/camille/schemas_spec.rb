
RSpec.describe Camille::Schemas do
  before(:all) do
    module Camille::Schemas::Api
    end

    module Camille::Schemas::Api::V1
    end

    module Camille::Schemas::Api::V2
    end

    class Camille::Schemas::Api::V1::Products < Camille::Schema
      get :data do
        params(id: Number)
        response(id: Number)
      end
    end

    class Camille::Schemas::Api::V1::Orders < Camille::Schema
    end

    class Camille::Schemas::Api::V2::OrderProducts < Camille::Schema
    end

    class Camille::Schemas::Api::Settings < Camille::Schema
    end

    class Camille::Schemas::Root < Camille::Schema
    end
  end

  after(:all) do
    Camille::Loader.loaded_schemas.delete(Camille::Schemas::Api::V1::Products)
    Camille::Loader.loaded_schemas.delete(Camille::Schemas::Api::V1::Orders)
    Camille::Loader.loaded_schemas.delete(Camille::Schemas::Api::V2::OrderProducts)
    Camille::Loader.loaded_schemas.delete(Camille::Schemas::Api::Settings)
    Camille::Loader.loaded_schemas.delete(Camille::Schemas::Root)
    Camille::Schemas.send(:remove_const, :Api)
  end

  describe '.literal_lines' do
    it 'returns the correct literal' do
      text = <<~EOF.chomp
      {
        api: {
          settings: {
          },
          v1: {
            orders: {
            },
            products: {
              data(params: {id: number}): Promise<{id: number}>{ return request('get', '/api/v1/products/data', params) },
            },
          },
          v2: {
            orderProducts: {
            },
          },
        },
        root: {
        },
      }
      EOF

      expect(Camille::Schemas.literal_lines.join("\n")).to eq(text)
    end
  end
end
