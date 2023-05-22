
RSpec.describe Camille::Types::Record do
  describe '#initialize' do
    it "accepts two types" do
      record = described_class.new(Camille::Types::Number, Camille::Types::String)
      expect(record).to be_an_instance_of(Camille::Types::Record)
      expect(record.key).to be_an_instance_of(Camille::Types::Number)
      expect(record.value).to be_an_instance_of(Camille::Types::String)
    end
  end

  describe '#transform_and_check' do
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
      error, transformed = record_type.transform_and_check({1 => '1', 2 => '2'})
      expect(error).to be nil
      expect(transformed).to eq({1 => '1', 2 => '2'})

      error, transformed = record_type.transform_and_check({})
      expect(error).to be nil
    end

    it 'performs transform' do
      time = Time.now

      error, transformed = record_type_with_date.transform_and_check({1 => time, 2 => time})
      expect(error).to be nil
      expect(transformed).to eq({1 => time.as_json, 2 => time.as_json})
    end

    it 'returns composite error if value has wrong type' do
      error, transformed = record_type.transform_and_check({1 => '1', 2 => 2})
      expect(error.basic?).to be false

      expect(error.components.keys.size).to eq(1)
      expect(error.components.keys.first).to eq('record[1]')
      expect(error.components.values.first.basic?).to be false
      expect(error.components.values.first.components.keys.size).to eq(1)
      expect(error.components.values.first.components.keys.first).to eq('record.value')
      expect(error.components.values.first.components.values.first.message).to eq('Expected string, got 2.')
    end

    it 'returns composite error if key has wrong type' do
      error, transformed = record_type.transform_and_check({1 => '1', '2' => '2'})
      expect(error.basic?).to be false

      expect(error.components.keys.size).to eq(1)
      expect(error.components.keys.first).to eq('record[1]')
      expect(error.components.values.first.basic?).to be false
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
end
