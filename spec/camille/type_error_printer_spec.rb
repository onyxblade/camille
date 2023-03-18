require 'stringio'

RSpec.describe Camille::TypeErrorPrinter do
  let(:basic_error){ Camille::Types::Number.new.transform_and_check('1')[0] }

  let(:composite_error){
    Camille::Types::Object.new(
      id: Camille::Types::Number | Camille::Types::Null,
      names: Camille::Types::Array.new(Camille::Types::String)
    ).transform_and_check({
      id: '1',
      names: ['1', 2, '3']
    })[0]
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
