
RSpec.describe Camille::Types::Record do
  describe '#initialize' do
    it "accepts two types" do
      record = described_class.new(Camille::Types::Number, Camille::Types::String)
      expect(record).to be_an_instance_of(Camille::Types::Record)
      expect(record.key).to be_an_instance_of(Camille::Types::Number)
      expect(record.value).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe '#check' do
    let(:record_type){
      described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )
    }

    let(:record_type_with_date){
      described_class.new(
        Camille::Types::Number,
        Camille::Types::DateTime
      )
    }

    it 'accepts values of the correct types' do
      result = record_type.check({1 => '1', 2 => '2'})
      expect(result).to have_checked_value({1 => '1', 2 => '2'})

      result = record_type.check({})
      expect(result).to have_checked_value({})
    end

    it 'performs transform' do
      time = Time.now

      result = record_type_with_date.check({1 => time, 2 => time})
      expect(result).to have_checked_value({1 => time.as_json, 2 => time.as_json})
    end

    it 'returns composite error if value has wrong type' do
      error = record_type.check({1 => '1', 2 => 2})
      expect(error).to be_composite_type_error

      expect(error.components.keys.size).to eq(1)
      expect(error.components.keys.first).to eq('record[1]')
      expect(error.components.values.first).to be_composite_type_error
      expect(error.components.values.first.components.keys.size).to eq(1)
      expect(error.components.values.first.components.keys.first).to eq('record.value')
      expect(error.components.values.first.components.values.first.message).to eq('Expected string, got 2.')
    end

    it 'returns composite error if key has wrong type' do
      error = record_type.check({1 => '1', '2' => '2'})
      expect(error).to be_composite_type_error

      expect(error.components.keys.size).to eq(1)
      expect(error.components.keys.first).to eq('record[1]')
      expect(error.components.values.first).to be_composite_type_error
      expect(error.components.values.first.components.keys.size).to eq(1)
      expect(error.components.values.first.components.keys.first).to eq('record.key')
      expect(error.components.values.first.components.values.first.message).to eq('Expected an integer or a float, got "2".')
    end

  end

  describe '.[]' do
    it 'constructs a record type' do
      record = described_class[
        Camille::Types::Number,
        Camille::Types::String
      ]
      expect(record).to be_an_instance_of(Camille::Types::Record)
      expect(record.key).to be_an_instance_of(Camille::Types::Number)
      expect(record.value).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe '#literal' do
    it 'returns correct literal' do
      record = described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )
      expect(record.literal).to eq('Record<number, string>')
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on key and value' do
      record_a = described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )

      record_a1 = described_class.new(
        Camille::Types::Number,
        Camille::Types::String
      )

      record_b = described_class.new(
        Camille::Types::String,
        Camille::Types::Number
      )

      expect(record_a.fingerprint).to eq(record_a1.fingerprint)
      expect(record_a.fingerprint).not_to eq(record_b.fingerprint)
    end
  end
end
