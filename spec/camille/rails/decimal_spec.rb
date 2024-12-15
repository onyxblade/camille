require 'rails_helper'

RSpec.describe Camille::Types::Decimal do
  describe '#check' do
    it 'transforms big decimals to numbers' do
      decimal = BigDecimal("1.2")
      result = Camille::Types::Decimal.new.check(decimal)
      expect(result).to have_checked_value(1.2)
    end

  end
end