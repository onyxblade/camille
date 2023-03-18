require 'camille/custom_types/date'

RSpec.describe Camille::CustomTypes::Date do

  describe '#transform_and_check' do
    it 'returns transformed value for Time' do
      date = described_class.new
      time = Time.now
      _, transformed = date.transform_and_check(time)
      expect(transformed).to eq({
        type: 'Date',
        value: time.to_i * 1000
      })
    end

    it 'returns transformed value for Date' do
      date = described_class.new
      date_object = Date.today
      _, transformed = date.transform_and_check(date_object)
      expect(transformed).to eq({
        type: 'Date',
        value: date_object.to_time.to_i * 1000
      })
    end

    it 'returns transformed value for DateTime' do
      date = described_class.new
      date_time = DateTime.now
      _, transformed = date.transform_and_check(date_time)
      expect(transformed).to eq({
        type: 'Date',
        value: date_time.to_time.to_i * 1000
      })
    end
  end
end
