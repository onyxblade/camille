
RSpec.describe Camille::Endpoint do
  let(:endpoint) { Camille::Endpoint.new :get, 'func' }

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
end
