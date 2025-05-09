
RSpec.describe Camille::Types::Array do
  describe '#initialize' do
    it 'accepts a content type' do
      array_of_numbers = Camille::Types::Array.new(Camille::Types::Number)
      expect(array_of_numbers.content).to be_an_instance_of(Camille::Types::Number)
    end

    it 'accepts a hash as content' do
      array_of_objects = Camille::Types::Array.new(
        id: Camille::Types::Number
      )
      expect(array_of_objects.content).to be_an_instance_of(Camille::Types::Object)
      expect(array_of_objects.content.fields[:id]).to be_an_instance_of(Camille::Types::Number)
    end
  end

  describe '#check' do
    let(:array_type){ described_class.new(Camille::Types::Number) }
    let(:date_array){ described_class.new(Camille::Types::DateTime) }

    it 'checks if value is correct array type' do
      array_type = described_class.new(Camille::Types::Number)
      expect(array_type.check([1, 2])).to have_checked_value([1, 2])
    end

    it 'returns basic error if value is not an array' do
      array_type = described_class.new(Camille::Types::Number)
      expect(array_type.check(1)).to be_basic_type_error
    end

    it 'returns composite error if value is an array' do
      array_type = described_class.new(Camille::Types::Number)
      error = array_type.check([1, '1'])

      expect(error).to be_composite_type_error
      expect(error.components.keys.first).to eq('array[1]')
      expect(error.components.values.first).to be_basic_type_error
    end

    it 'returns transformed value for date' do
      time = Time.now

      expect(date_array.check([time, time])).to have_checked_value([time.as_json] * 2)
    end

    it 'returns nested transformed values' do
      type = Camille::Types::DateTime[][]
      time = Time.now

      expect(type.check([[time]])).to have_checked_value([[time.as_json]])
    end
  end

  describe '#literal' do
    it 'returns correct literal' do
      array = described_class.new(
        Camille::Types::Number
      )
      expect(array.literal).to eq('number[]')
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on content' do
      array_a = described_class.new(
        Camille::Types::Number
      )

      array_a1 = described_class.new(
        Camille::Types::Number
      )

      array_b = described_class.new(
        Camille::Types::String
      )

      expect(array_a.fingerprint).to eq(array_a1.fingerprint)
      expect(array_a.fingerprint).not_to eq(array_b.fingerprint)
    end
  end

end
