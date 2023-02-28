
RSpec.describe Camille::Types::Object do
  it "accepts a hash of fields" do
    object = Camille::Types::Object.new(
      id: Camille::Types::Number.new,
      name: Camille::Types::String.new
    )
    expect(object.fields[:id]).to be_an_instance_of(Camille::Types::Number)
    expect(object.fields[:name]).to be_an_instance_of(Camille::Types::String)
  end

end
