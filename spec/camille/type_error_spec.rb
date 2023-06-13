
RSpec.describe Camille::TypeError do
  describe '#initialize' do
    it 'accepts one string or one hash' do
      expect{Camille::TypeError.new('string')}.not_to raise_error
      expect{Camille::TypeError.new(a: '1', b: '2')}.not_to raise_error
      expect{Camille::TypeError.new(1)}.to raise_error(Camille::TypeError::ArgumentError)
    end
  end

  describe '#basic?' do
    it 'returns true if a string error message presented' do
      expect(Camille::TypeError.new('string').basic?).to be true
      expect(Camille::TypeError.new(a: '1').basic?).to be false
    end
  end

end
