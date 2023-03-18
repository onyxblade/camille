require 'rails_helper'

RSpec.describe Camille::Types::Decimal do
  describe '#transform_and_check' do
    it 'transforms big decimals to numbers' do
      decimal = BigDecimal("1.2")
      result, transformed = Camille::Types::Decimal.new.transform_and_check(decimal)
      expect(result).to be nil
      expect(transformed).to eq(1.2)
    end

  end
end