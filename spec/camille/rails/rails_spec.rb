require 'rails_helper'

RSpec.describe 'Rails' do
  it 'has application' do
    expect(Rails.application).to be_an_instance_of(Dummy::Application)
  end
end
