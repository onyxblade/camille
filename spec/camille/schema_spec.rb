
RSpec.describe Camille::Schema do
  before(:all) do
    class Camille::Schemas::SchemaSpec < Camille::Schema
      include Camille::Types

      get :show do
        params(
          id: Number
        )

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

      post :do_something do
        response(Boolean)
      end

      put :replace do
        params(
          id: Number,
          name: String
        )

        response(Boolean)
      end

      patch :rename do
        params(
          id: Number,
          name: String
        )

        response(Boolean)
      end

      delete :remove do
        params(
          id: Number
        )

        response(Boolean)
      end
    end

    class Camille::Schemas::SchemaSpec::Nested < Camille::Schema
    end
  end

  after(:all) do
    Camille::Loader.loaded_schemas.delete(Camille::Schemas::SchemaSpec)
    Camille::Loader.loaded_schemas.delete(Camille::Schemas::SchemaSpec::Nested)
    Camille::Schemas.send(:remove_const, :SchemaSpec)
  end

  describe '.get' do
    it 'defines an endpoint' do
      endpoint = Camille::Schemas::SchemaSpec.endpoints[:show]

      expect(endpoint.verb).to eq(:get)
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Object)
      expect(endpoint.response_type).to be_an_instance_of(Camille::Types::Object)
    end
  end

  describe '.post' do
    it 'defines an endpoint' do
      endpoint = Camille::Schemas::SchemaSpec.endpoints[:update]

      expect(endpoint.verb).to eq(:post)
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Object)
      expect(endpoint.response_type).to be_an_instance_of(Camille::Types::Boolean)
    end
  end

  describe '.put' do
    it 'defines an endpoint' do
      endpoint = Camille::Schemas::SchemaSpec.endpoints[:replace]

      expect(endpoint.verb).to eq(:put)
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Object)
      expect(endpoint.response_type).to be_an_instance_of(Camille::Types::Boolean)
    end
  end

  describe '.patch' do
    it 'defines an endpoint' do
      endpoint = Camille::Schemas::SchemaSpec.endpoints[:rename]

      expect(endpoint.verb).to eq(:patch)
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Object)
      expect(endpoint.response_type).to be_an_instance_of(Camille::Types::Boolean)
    end
  end

  describe '.delete' do
    it 'defines an endpoint' do
      endpoint = Camille::Schemas::SchemaSpec.endpoints[:remove]

      expect(endpoint.verb).to eq(:delete)
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Object)
      expect(endpoint.response_type).to be_an_instance_of(Camille::Types::Boolean)
    end
  end

  describe '.define_endpoint' do
    it 'raises if endpoint name is already defined' do
      expect {
        Camille::Schemas::SchemaSpec.instance_exec do
          get :update do

          end
        end
      }.to raise_error(Camille::Schema::AlreadyDefinedError)
    end
  end

  describe '.path' do
    it 'returns correct path' do
      expect(Camille::Schemas::SchemaSpec.path).to eq('/schema_spec')
      expect(Camille::Schemas::SchemaSpec::Nested.path).to eq('/schema_spec/nested')
    end
  end

  describe '.literal_lines' do
    it 'returns correct literal' do
      schema = Camille::Schemas::SchemaSpec

      text = <<~EOF.chomp
      {
        doSomething(): Promise<boolean>{ return request('post', '/schema_spec/do_something', {}) },
        remove(params: {id: number}): Promise<boolean>{ return request('delete', '/schema_spec/remove', params) },
        rename(params: {id: number, name: string}): Promise<boolean>{ return request('patch', '/schema_spec/rename', params) },
        replace(params: {id: number, name: string}): Promise<boolean>{ return request('put', '/schema_spec/replace', params) },
        show(params: {id: number}): Promise<{name: string}>{ return request('get', '/schema_spec/show', params) },
        update(params: {id: number, name: string}): Promise<boolean>{ return request('post', '/schema_spec/update', params) },
      }
      EOF

      expect(schema.literal_lines.join("\n")).to eq(text)
    end
  end

  describe '.inherited' do
    it 'add subclass to Loader.loaded_schemas' do
      expect(Camille::Loader.loaded_schemas).to contain_exactly(Camille::Schemas::SchemaSpec, Camille::Schemas::SchemaSpec::Nested)
    end
  end
end
