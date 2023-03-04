
module CamilleTypeSpec
  class NewType < Camille::Type
    alias_of(Number)
  end
end

RSpec.describe Camille::Type do
  describe '.alias_of' do
    it 'defines type alias' do
      expect(CamilleTypeSpec::NewType.new.underlying).to be_an_instance_of(Camille::Types::Number)
    end
  end

  describe '#check' do
    it 'uses the underlying type to check' do
      expect(CamilleTypeSpec::NewType.new.check(1)).to be nil
      expect(CamilleTypeSpec::NewType.new.check('1')).to be_an_instance_of(Camille::TypeError)
    end
  end

  describe '#directly_instantiable?' do
    it 'returns true' do
      expect(CamilleTypeSpec::NewType.directly_instantiable?).to be true
    end
  end

  describe '#initialize' do
    it 'raises if no `alias_of` definition available' do
      expect{Class.new(Camille::Type).new}.to raise_error(Camille::Type::NotImplementedError)
    end
  end
end
