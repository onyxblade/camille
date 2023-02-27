
RSpec.describe Camille::Types::Array do
  it "accepts a content type" do
    array_of_numbers = Camille::Types::Array.new(Camille::Types::Number.new)
    expect(array_of_numbers.content_type).to be_an_instance_of(Camille::Types::Number)
  end

end
