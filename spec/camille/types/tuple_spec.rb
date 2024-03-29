
RSpec.describe Camille::Types::Tuple do
  describe '#initialize' do
    it 'accepts an array of elements' do
      tuple = described_class.new([Camille::Types::Number, Camille::Types::String])
      expect(tuple.elements[0]).to be_an_instance_of(Camille::Types::Number)
      expect(tuple.elements[1]).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe '#transform_and_check' do
    it 'checks if value is correct tuple type' do
      tuple_type = described_class.new([Camille::Types::Number, Camille::Types::String])

      error, transformed = tuple_type.transform_and_check([1, 'name'])
      expect(error).to be nil
      expect(transformed).to eq([1, 'name'])
    end

    it 'returns basic error if value is not an array' do
      tuple_type = described_class.new([Camille::Types::Number, Camille::Types::String])

      error, transformed = tuple_type.transform_and_check(1)

      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be true
    end

    it 'returns composite error if value is an array' do
      tuple_type = described_class.new([Camille::Types::Number, Camille::Types::String])

      error, transformed = tuple_type.transform_and_check([1, 1])

      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('tuple[1]')
      expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.first.basic?).to be true
    end

    it 'returns transformed value for date' do
      time = Time.now
      type = described_class.new([Camille::Types::Number, Camille::Types::DateTime])
      error, transformed = type.transform_and_check([1, time])

      expect(error).to be nil
      expect(transformed).to eq([1, time.as_json])
    end

    it 'returns nested transformed values' do
      time = Time.now
      type = described_class.new([described_class.new([1, Camille::Types::DateTime])])

      errors, transformed = type.transform_and_check([[1, time]])
      expect(errors).to be nil
      expect(transformed).to eq([[1, time.as_json]])
    end
  end

  describe '#literal' do
    it 'returns correct literal' do
      tuple = described_class.new([Camille::Types::Number, Camille::Types::String])
      expect(tuple.literal).to eq('[number, string]')
    end
  end

end
