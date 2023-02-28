
RSpec.describe Camille::Types::Union do
  it "accepts two types" do
    union = Camille::Types::Union.new(Camille::Types::Number.new, Camille::Types::String.new)
    expect(union).to be_an_instance_of(Camille::Types::Union)
  end

end
