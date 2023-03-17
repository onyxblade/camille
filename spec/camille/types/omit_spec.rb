using Camille::Syntax

RSpec.describe Camille::Types::Omit do
  before(:all) do
    class Camille::Types::ObjectAlias < Camille::Type
      include Camille::Types

      alias_of(
        a: Number,
        b: Number,
        c: Number
      )
    end
  end

  after(:all) do
    Camille::Loader.loaded_types.delete(Camille::Types::ObjectAlias)
    Camille::Types.send(:remove_const, :ObjectAlias)
  end

  describe '#initialize' do
    it 'raises unless receiving an object type or an alias of object type' do
      expect{Camille::Types::Omit.new({a: 1}, 'a')}.not_to raise_error
      expect{Camille::Types::Omit.new(Camille::Types::ObjectAlias, 'a')}.not_to raise_error
      expect{Camille::Types::Omit.new(Camille::Types::Number, 'a')}.to raise_error(Camille::Types::Omit::ArgumentError)
    end

    it 'raises unless receiving a string literal or a union of literals' do
      expect{Camille::Types::Omit.new({a: 1}, 'a')}.not_to raise_error
      expect{Camille::Types::Omit.new({a: 1}, 'a' | 'b')}.not_to raise_error
      expect{Camille::Types::Omit.new({a: 1}, 'a' | 'b' | 1)}.to raise_error(Camille::Types::Omit::ArgumentError)
    end
  end

  describe '#check' do
    it 'checks the value with keys omited' do
      object = {
        a: Camille::Types::Number,
        b: Camille::Types::Number,
        c: Camille::Types::Number
      }

      expect(Camille::Types::Omit.new(object, 'a').check({b: 1, c: 2})).to be nil
      expect(Camille::Types::Omit.new(object, 'a').check({b: 1})).to be_instance_of(Camille::TypeError)
      expect(Camille::Types::Omit.new(object, 'a' | 'b').check({c: 1})).to be nil
      expect(Camille::Types::Omit.new(object, 'a' | 'b').check({})).to be_instance_of(Camille::TypeError)
      expect(Camille::Types::Omit.new(object, 'a' | 'b' | 'c').check({})).to be nil

      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, 'a').check({b: 1, c: 2})).to be nil
      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, 'a').check({b: 1})).to be_instance_of(Camille::TypeError)
      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, 'a' | 'b').check({c: 1})).to be nil
      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, 'a' | 'b').check({})).to be_instance_of(Camille::TypeError)
      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, 'a' | 'b' | 'c').check({})).to be nil
    end
  end

  describe '#literal' do
    it 'returns literal for objects' do
      expect(Camille::Types::Omit.new({a: 1}, 'a').literal).to eq('Omit<{a: 1}, "a">')
      expect(Camille::Types::Omit.new({a: 1}, 'a' | 'b').literal).to eq('Omit<{a: 1}, "a" | "b">')
      expect(Camille::Types::Omit.new({a: 1}, 'a' | 'b' | 'c').literal).to eq('Omit<{a: 1}, "a" | "b" | "c">')
    end

    it 'returns liter for object aliases' do
      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, 'a' | 'b').literal).to eq('Omit<ObjectAlias, "a" | "b">')
    end
  end

  describe '.[]' do
    it 'instantiates an omit type' do
      expect(Camille::Types::Omit[{a: 1}, 'a']).to be_instance_of(Camille::Types::Omit)
    end
  end
end
