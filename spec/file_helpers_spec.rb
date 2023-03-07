require "fileutils"

RSpec.describe FileHelpers do
  describe '#rewrite_file' do
    it 'rewrites the file within block' do
      path = "#{__dir__}/test_file_helpers"

      File.open(path, 'w'){|f| f.write 'abc'}
      expect(File.open(path, &:read)).to eq('abc')

      yielded = false

      rewrite_file(path, 'def') do
        yielded = true
        expect(File.open(path, &:read)).to eq('def')
      end

      expect(yielded).to be true

      expect(File.open(path, &:read)).to eq('abc')
      FileUtils.rm(path)
    end
  end
end