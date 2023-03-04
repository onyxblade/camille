
module CamilleSchemaSpec
  class Schema < Camille::Schema
    get :show do
      params(Number)

      response(
        name: String
      )
    end

    post :update do
      params(
        id: Number,
        name: String
      )

      response(
        Boolean
      )
    end
  end
end

RSpec.describe Camille::Schema do
  describe '.get' do
    it 'defines an endpoint' do
      endpoint = CamilleSchemaSpec::Schema.endpoints[:show]

      expect(endpoint.verb).to eq(:get)
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Number)
      expect(endpoint.response_type).to be_an_instance_of(Camille::Types::Object)
    end
  end

  describe '.post' do
    it 'defines an endpoint' do
      endpoint = CamilleSchemaSpec::Schema.endpoints[:update]

      expect(endpoint.verb).to eq(:post)
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Object)
      expect(endpoint.response_type).to be_an_instance_of(Camille::Types::Boolean)
    end
  end
end
