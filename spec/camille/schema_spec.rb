
RSpec.describe Camille::Schema do
  before(:all) do
    class Camille::Schemas::SchemaSpec < Camille::Schema
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
    end

    class Camille::Schemas::SchemaSpec::Nested < Camille::Schema
    end
  end

  after(:all) do
    Camille::Schemas.loaded_schemas.delete(Camille::Schemas::SchemaSpec)
    Camille::Schemas.loaded_schemas.delete(Camille::Schemas::SchemaSpec::Nested)
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

      expect(schema.literal_lines).to eq([
        Camille::Line.new('{'),
        *schema.endpoints.values.map do |e|
          Camille::Line.new("#{e.function},")
        end.map(&:do_indent),
        Camille::Line.new('}')
      ])
    end
  end

  describe '.inherited' do
    it 'add subclass to Schemas.loaded_schemas' do
      expect(Camille::Schemas.loaded_schemas).to contain_exactly(Camille::Schemas::SchemaSpec, Camille::Schemas::SchemaSpec::Nested)
    end
  end
end
