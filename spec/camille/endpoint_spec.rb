
RSpec.describe Camille::Endpoint do
  before(:all) do
    class Camille::Schemas::EndpointSpec < Camille::Schema
    end
  end

  after(:all) do
    Camille::Loader.loaded_schemas.delete(Camille::Schemas::EndpointSpec)
    Camille::Schemas.send(:remove_const, :EndpointSpec)
  end

  let(:endpoint) { Camille::Endpoint.new Camille::Schemas::EndpointSpec, :get, 'func' }

  describe '#params' do
    it 'sets params_type' do
      endpoint.instance_exec do
        params(id: Camille::Types::Number)
      end
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Object)
      expect(endpoint.params_type.fields[:id]).to be_an_instance_of(Camille::Types::Number)
    end

    it 'raises when params is not a hash or nil' do
      expect{
        endpoint.instance_exec do
          params(Camille::Types::Number)
        end
      }.to raise_error(Camille::Endpoint::ArgumentError)
    end
  end

  describe '#response' do
    it 'sets response_type' do
      endpoint.instance_exec do
        response(
          id: Camille::Types::Number
        )
      end
      expect(endpoint.response_type).to be_an_instance_of(Camille::Types::Object)
    end
  end

  describe '#signature' do
    it 'returns the signature' do
      endpoint.instance_exec do
        params(id: Camille::Types::Number)
        response(id: Camille::Types::Number)
      end
      expect(endpoint.signature).to eq('func(params: {id: number}): Promise<{id: number}>')
    end

    it 'returns the signature for empty params' do
      endpoint.instance_exec do
        response(id: Camille::Types::Number)
      end
      expect(endpoint.signature).to eq('func(): Promise<{id: number}>')
    end

    it 'raises when response_type is nil' do
      endpoint.instance_exec do
        params(id: Camille::Types::Number)
      end
      expect{endpoint.signature}.to raise_error(Camille::Endpoint::UnknownResponseError)
    end
  end

  describe '#path' do
    it 'returns the correct path' do
      expect(endpoint.path).to eq("#{endpoint.schema.path}/func")
    end
  end

  describe '#function' do
    it 'returns the function' do
      endpoint.instance_exec do
        params(id: Camille::Types::Number)
        response(id: Camille::Types::Number)
      end

      expect(endpoint.function).to eq("#{endpoint.signature}{ return request('get', '#{endpoint.path}', params) }")
    end
  end
end
