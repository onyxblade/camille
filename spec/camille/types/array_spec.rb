
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

    it 'checks if value is correct array type' do
      expect(array_type.check([1, 2])).to be nil
    end

    it 'returns basic error if value is not an array' do
      expect(array_type.check(1)).to be_an_instance_of(Camille::TypeError)
      expect(array_type.check(1).basic?).to be true
    end

    it 'returns composite error if value is an array' do
      error = array_type.check([1, '1'])
      expect(error).to be_an_instance_of(Camille::TypeError)
      expect(error.basic?).to be false
      expect(error.components.keys.first).to eq('array[1]')
      expect(error.components.values.first).to be_an_instance_of(Camille::TypeError)
      expect(error.components.values.first.basic?).to be true
    end
  end

  describe '#check_and_transform' do
    let(:array_type){ described_class.new(Camille::Types::Number) }
    let(:date_array){ described_class.new(Camille::Types::Date) }

    it 'returns transformed value' do
      _, transformed = array_type.check_and_transform([1, 2, 3])
      expect(transformed).to eq([1, 2, 3])
    end

    it 'returns transformed value for date' do
      time = Time.now
      _, transformed = date_array.check_and_transform([time, time])

      expect(transformed).to eq([{
        '?': 'Date',
        value: time.to_i * 1000
      }] * 2)
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

end
