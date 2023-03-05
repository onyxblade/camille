
RSpec.describe Camille::Line do
  describe '#do_indent' do
    it 'adds indent by 2' do
      line = Camille::Line.new('string', 2)
      expect(line.do_indent.indent).to eq(4)
    end
  end

  describe '#prepend' do
    it 'prepends content to the string' do
      line = Camille::Line.new('abc', 2)
      expect(line.prepend('def').string).to eq('defabc')
    end
  end

  describe '#append' do
    it 'appends content to the string' do
      line = Camille::Line.new('abc', 2)
      expect(line.append('def').string).to eq('abcdef')
    end
  end

  describe '#to_s' do
    it 'indents the right number' do
      line = Camille::Line.new('abc', 2)
      expect(line.to_s).to eq('  abc')
    end
  end

  describe '.join' do
    it 'joins lines by delimiter' do
      lines = [
        Camille::Line.new('abc'),
        Camille::Line.new('def'),
        Camille::Line.new('ghi')
      ]

      Camille::Line.join(lines, ',')

      expect(lines[0].string).to eq('abc,')
      expect(lines[1].string).to eq('def,')
      expect(lines[2].string).to eq('ghi')
    end
  end
end
