
RSpec.describe Camille::Types::Date do
  describe '#check' do
    it 'returns TypeError if value is not date or time' do
      date = described_class.new
      expect(date.check(Time.now)).to be nil
      expect(date.check(Date.today)).to be nil
      expect(date.check(DateTime.now)).to be nil
      expect(date.check(1)).to be_an_instance_of(Camille::TypeError)
      expect(date.check(1).basic?).to be true
    end
  end

  describe '#check_and_transform' do
    it 'returns transformed value for Time' do
      date = described_class.new
      time = Time.now
      _, transformed = date.check_and_transform(time)
      expect(transformed).to eq({
        '?': 'Date',
        value: time.to_i * 1000
      })
    end

    it 'returns transformed value for Date' do
      date = described_class.new
      date_object = Date.today
      _, transformed = date.check_and_transform(date_object)
      expect(transformed).to eq({
        '?': 'Date',
        value: date_object.to_time.to_i * 1000
      })
    end

    it 'returns transformed value for DateTime' do
      date = described_class.new
      date_time = DateTime.now
      _, transformed = date.check_and_transform(date_time)
      expect(transformed).to eq({
        '?': 'Date',
        value: date_time.to_time.to_i * 1000
      })
    end
  end
end
