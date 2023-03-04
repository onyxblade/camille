
RSpec.describe Camille::Endpoint do
  let(:endpoint) { Camille::Endpoint.new :get }

  describe '#params' do
    it 'sets params_type' do
      endpoint.instance_exec do
        params(Camille::Types::Number)
      end
      expect(endpoint.params_type).to be_an_instance_of(Camille::Types::Number)
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
end
