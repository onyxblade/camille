require 'rails_helper'

RSpec.describe Camille::Types::DateTime do
  describe '#transform_and_check' do
    it 'transforms Time object' do
      time = Time.new(2002, 10, 31, 2, 2, 2, '+02:00')
      result, transformed = Camille::Types::DateTime.new.transform_and_check(time)
      expect(result).to be nil
      expect(transformed).to eq('2002-10-31T02:02:02.000+02:00')
    end

    it 'transforms Date object' do
      date = Date.new(1999, 12, 31)
      result, transformed = Camille::Types::DateTime.new.transform_and_check(date)
      expect(result).to be nil
      expect(transformed).to eq('1999-12-31')
    end

    it 'transforms DateTime object' do
      date_time = ::DateTime.new(2001, 2, 3, 4, 5, 6, '+03:00')
      result, transformed = Camille::Types::DateTime.new.transform_and_check(date_time)
      expect(result).to be nil
      expect(transformed).to eq('2001-02-03T04:05:06.000+03:00')
    end

    it 'transforms ActiveSupport::TimeWithZone object' do
      Time.zone = 'Eastern Time (US & Canada)'
      time = Time.zone.local(2007, 2, 10, 15, 30, 45)
      result, transformed = Camille::Types::DateTime.new.transform_and_check(time)
      expect(result).to be nil
      expect(transformed).to eq('2007-02-10T15:30:45.000-05:00')
    end
  end
end