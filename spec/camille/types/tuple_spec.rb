
RSpec.describe Camille::Types::Tuple do
  describe '#initialize' do
    it 'accepts an array of elements' do
      tuple = described_class.new([Camille::Types::Number, Camille::Types::String])
      expect(tuple.elements[0]).to be_an_instance_of(Camille::Types::Number)
      expect(tuple.elements[1]).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe '#check' do
    it 'checks if value is correct tuple type' do
      tuple_type = described_class.new([Camille::Types::Number, Camille::Types::String])

      result = tuple_type.check([1, 'name'])
      expect(result).to have_checked_value([1, 'name'])
    end

    it 'returns basic error if value is not an array' do
      tuple_type = described_class.new([Camille::Types::Number, Camille::Types::String])

      error = tuple_type.check(1)

      expect(error).to be_basic_type_error
    end

    it 'returns basic error if value is of wrong size' do
      tuple_type = described_class.new([Camille::Types::Number, Camille::Types::String])

      error = tuple_type.check([1, '2', 3])

      expect(error).to be_basic_type_error
    end

    it 'returns composite error if value is an array' do
      tuple_type = described_class.new([Camille::Types::Number, Camille::Types::String])

      error = tuple_type.check([1, 1])

      expect(error).to be_composite_type_error
      expect(error.components.keys.first).to eq('tuple[1]')
      expect(error.components.values.first).to be_basic_type_error
    end

    it 'returns transformed value for date' do
      time = Time.now
      type = described_class.new([Camille::Types::Number, Camille::Types::DateTime])
      result = type.check([1, time])

      expect(result).to have_checked_value([1, time.as_json])
    end

    it 'returns nested transformed values' do
      time = Time.now
      type = described_class.new([described_class.new([1, Camille::Types::DateTime])])

      result = type.check([[1, time]])
      expect(result).to have_checked_value([[1, time.as_json]])
    end
  end

  describe '#literal' do
    it 'returns correct literal' do
      tuple = described_class.new([Camille::Types::Number, Camille::Types::String])
      expect(tuple.literal).to eq('[number, string]')
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on elements' do
      tuple_a = described_class.new([Camille::Types::Number, Camille::Types::String])
      tuple_a1 = described_class.new([Camille::Types::Number, Camille::Types::String])
      tuple_b = described_class.new([Camille::Types::String, Camille::Types::Number])

      expect(tuple_a.fingerprint).to eq(tuple_a1.fingerprint)
      expect(tuple_a.fingerprint).not_to eq(tuple_b.fingerprint)
    end
  end

end
