require 'rails_helper'

RSpec.describe 'Controller with Camille::ControllerExtension' do
  describe '#camille_schema' do
    it 'finds the corresponding schema' do
      expect(ProductsController.new.camille_schema).to be(Camille::Schemas::Products)
    end
  end
end
