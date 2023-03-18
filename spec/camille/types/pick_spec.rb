using Camille::Syntax

RSpec.describe Camille::Types::Pick do
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
      expect{Camille::Types::Pick.new({a: 1}, 'a')}.not_to raise_error
      expect{Camille::Types::Pick.new(Camille::Types::ObjectAlias, 'a')}.not_to raise_error
      expect{Camille::Types::Pick.new(Camille::Types::Number, 'a')}.to raise_error(Camille::Types::Pick::ArgumentError)
    end

    it 'raises unless receiving a string literal or a union of literals' do
      expect{Camille::Types::Pick.new({a: 1}, 'a')}.not_to raise_error
      expect{Camille::Types::Pick.new({a: 1}, 'a' | 'b')}.not_to raise_error
      expect{Camille::Types::Pick.new({a: 1}, 'a' | 'b' | 1)}.to raise_error(Camille::Types::Pick::ArgumentError)
    end
  end

  describe '#transform_and_check' do
    it 'checks the value with keys picked' do
      object = {
        a: Camille::Types::Number,
        b: Camille::Types::Number,
        c: Camille::Types::Number
      }

      error, transformed = Camille::Types::Pick.new(object, 'a').transform_and_check({a: 1})
      expect(error).to be nil
      expect(transformed).to eq({a: 1})

      error, transformed = Camille::Types::Pick.new(object, 'a' | 'b').transform_and_check({a: 1, b: 2})
      expect(error).to be nil
      expect(transformed).to eq({a: 1, b: 2})

      expect(Camille::Types::Pick.new(object, 'a' | 'b' | 'c').transform_and_check({a: 1, b: 2})[0]).to be_instance_of(Camille::TypeError)

      error, transformed = Camille::Types::Pick.new(Camille::Types::ObjectAlias, 'a').transform_and_check({a: 1})
      expect(error).to be nil
      expect(transformed).to eq({a: 1})

      error, transformed = Camille::Types::Pick.new(Camille::Types::ObjectAlias, 'a' | 'b').transform_and_check({a: 1, b: 2})
      expect(error).to be nil
      expect(transformed).to eq({a: 1, b: 2})

      expect(Camille::Types::Pick.new(Camille::Types::ObjectAlias, 'a' | 'b' | 'c').transform_and_check({a: 1, b: 2})[0]).to be_instance_of(Camille::TypeError)
    end

    it 'returns the transformed value' do
      object = {
        a: Camille::Types::Number,
        b: Camille::Types::Number,
        c: Camille::Types::Number
      }

      _, transformed = Camille::Types::Pick.new(object, 'a').transform_and_check({a: 1})
      expect(transformed).to eq({a: 1})
    end
  end

  describe '#literal' do
    it 'returns literal for objects' do
      expect(Camille::Types::Pick.new({a: 1}, 'a').literal).to eq('Pick<{a: 1}, "a">')
      expect(Camille::Types::Pick.new({a: 1}, 'a' | 'b').literal).to eq('Pick<{a: 1}, "a" | "b">')
      expect(Camille::Types::Pick.new({a: 1}, 'a' | 'b' | 'c').literal).to eq('Pick<{a: 1}, "a" | "b" | "c">')
    end

    it 'returns liter for object aliases' do
      expect(Camille::Types::Pick.new(Camille::Types::ObjectAlias, 'a' | 'b').literal).to eq('Pick<ObjectAlias, "a" | "b">')
    end
  end

  describe '.[]' do
    it 'instantiates a pick type' do
      expect(Camille::Types::Pick[{a: 1}, 'a']).to be_instance_of(Camille::Types::Pick)
    end
  end

end
