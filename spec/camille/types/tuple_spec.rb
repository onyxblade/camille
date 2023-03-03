
RSpec.describe Camille::Types::Tuple do
  describe '#initialize' do
    it 'accepts an array of elements' do
      tuple = described_class.new([Camille::Types::Number, Camille::Types::String])
      expect(tuple.elements[0]).to be_an_instance_of(Camille::Types::Number)
      expect(tuple.elements[1]).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe '#check' do
    let(:tuple_type){
      described_class.new([Camille::Types::Number, Camille::Types::String])
    }

    it 'checks if value is correct tuple type' do
      expect(tuple_type.check([1, 'name'])).to be nil
    end

    it 'returns basic error if value is not an array' do
      expect(tuple_type.check(1)).to be_an_instance_of(Camille::TypeError)
      expect(tuple_type.check(1).basic?).to be true
    end

    it 'returns composite error if value is an array' do
      error = tuple_type.check([1, 1])
      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('tuple[1]')
      expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.first.basic?).to be true
    end

  end

end
