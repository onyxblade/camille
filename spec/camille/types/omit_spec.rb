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
      expect{Camille::Types::Omit.new({a: 1}, [:a])}.not_to raise_error
      expect{Camille::Types::Omit.new(Camille::Types::ObjectAlias, [:a])}.not_to raise_error
      expect{Camille::Types::Omit.new(Camille::Types::Number, [:a])}.to raise_error(Camille::Types::Omit::ArgumentError)
    end

    it 'raises unless receiving a string literal or a union of literals' do
      expect{Camille::Types::Omit.new({a: 1}, [:a])}.not_to raise_error
      expect{Camille::Types::Omit.new({a: 1}, [:a, :b])}.not_to raise_error
      expect{Camille::Types::Omit.new({a: 1}, [:a, :b, 1])}.to raise_error(Camille::Types::Omit::ArgumentError)
    end
  end

  describe '#transform_and_check' do
    it 'returns the transformed value' do
      object = {
        a: Camille::Types::Number,
        b: Camille::Types::Number,
        c: Camille::Types::Number
      }

      error, transformed = Camille::Types::Omit.new(object, [:a]).transform_and_check({b: 1, c: 2})
      expect(error).to be nil
      expect(transformed).to eq({b: 1, c: 2})

      expect(Camille::Types::Omit.new(object, [:a]).transform_and_check({b: 1})[0]).to be_instance_of(Camille::TypeError)

      error, transformed = Camille::Types::Omit.new(object, [:a, :b]).transform_and_check({c: 1})
      expect(error).to be nil
      expect(transformed).to eq({c: 1})

      expect(Camille::Types::Omit.new(object, [:a, :b]).transform_and_check({})[0]).to be_instance_of(Camille::TypeError)

      error, transformed = Camille::Types::Omit.new(object, [:a, :b, :c]).transform_and_check({})
      expect(error).to be nil
      expect(transformed).to eq({})

      error, transformed = Camille::Types::Omit.new(Camille::Types::ObjectAlias, [:a]).transform_and_check({b: 1, c: 2})
      expect(error).to be nil
      expect(transformed).to eq({b: 1, c: 2})

      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, [:a]).transform_and_check({b: 1})[0]).to be_instance_of(Camille::TypeError)

      error, transformed = Camille::Types::Omit.new(Camille::Types::ObjectAlias, [:a, :b]).transform_and_check({c: 1})
      expect(error).to be nil
      expect(transformed).to eq({c: 1})

      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, [:a, :b]).transform_and_check({})[0]).to be_instance_of(Camille::TypeError)

      error, transformed = Camille::Types::Omit.new(Camille::Types::ObjectAlias, [:a, :b, :c]).transform_and_check({})
      expect(error).to be nil
      expect(transformed).to eq({})
    end

    it 'handles keys of snake case' do
      object = {
        long_name: Camille::Types::Number
      }
      type = Camille::Types::Omit.new(object, [:long_name])
      error, transformed = type.transform_and_check({})
      expect(error).to be nil
    end

    it 'preserves optional fields' do
      object = {
        id: Camille::Types::Number,
        name?: Camille::Types::String,
        price: Camille::Types::Number
      }
      type = Camille::Types::Omit.new(object, [:price])
      error, transformed = type.transform_and_check({id: 1})
      expect(error).to be nil
    end
  end

  describe '#literal' do
    it 'returns literal for objects' do
      expect(Camille::Types::Omit.new({a: 1}, [:a]).literal).to eq('Omit<{a: 1}, "a">')
      expect(Camille::Types::Omit.new({a: 1}, [:a, :b]).literal).to eq('Omit<{a: 1}, "a" | "b">')
      expect(Camille::Types::Omit.new({a: 1}, [:a, :b, :c]).literal).to eq('Omit<{a: 1}, "a" | "b" | "c">')
    end

    it 'returns liter for object aliases' do
      expect(Camille::Types::Omit.new(Camille::Types::ObjectAlias, [:a, :b]).literal).to eq('Omit<ObjectAlias, "a" | "b">')
    end

    it 'handles keys of snake case' do
      object = {
        long_name: Camille::Types::Number
      }
      type = Camille::Types::Omit.new(object, [:long_name])

      expect(type.literal).to eq('Omit<{longName: number}, "longName">')
    end
  end

  describe '.[]' do
    it 'instantiates an omit type' do
      expect(Camille::Types::Omit[{a: 1}, [:a]]).to be_instance_of(Camille::Types::Omit)
    end
  end

  describe '#fingerprint' do
    it 'returns fingerprint based on content' do
      omit_a = described_class.new(
        {a: 1, b: 2, c: 3},
        [:a, :b]
      )

      omit_a1 = described_class.new(
        {a: 1, b: 2, c: 3},
        [:b, :a]
      )

      omit_b = described_class.new(
        {a: 1, b: 2, c: 3},
        [:a]
      )

      expect(omit_a.fingerprint).to eq(omit_a1.fingerprint)
      expect(omit_a.fingerprint).not_to eq(omit_b.fingerprint)
    end
  end
end
