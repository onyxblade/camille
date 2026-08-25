require 'rails_helper'

RSpec.describe 'Controller with Camille::Controller' do
  describe '#camille_schema' do
    it 'finds the corresponding schema' do
      expect(ProductsController.new.camille_schema).to be(Camille::Schemas::Products)
    end
  end

  describe 'ArgumentError' do
    it 'does not shadow the top-level ArgumentError inside including controllers' do
      expect {
        ProductsController.new.raise_plain_argument_error
      }.to raise_error(::ArgumentError) { |e| expect(e.class).to eq(::ArgumentError) }
    end
  end
end
