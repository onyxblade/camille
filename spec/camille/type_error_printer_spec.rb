require 'stringio'

RSpec.describe Camille::TypeErrorPrinter do
  let(:basic_error){ Camille::Types::Number.new.check('1') }

  let(:composite_error){
    Camille::Types::Object.new(
      id: Camille::Types::Number.new | Camille::Types::Null.new,
      names: Camille::Types::Array.new(Camille::Types::String.new)
    ).check({
      id: '1',
      names: ['1', 2, '3']
    })
  }

  # not sure how to test printed content
  describe '#print' do
    it 'prints basic type error' do
      described_class.new(basic_error).print(StringIO.new)
    end

    it 'prints composite type error' do
      described_class.new(composite_error).print(StringIO.new)
    end
  end
end
