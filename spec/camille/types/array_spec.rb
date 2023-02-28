
RSpec.describe Camille::Types::Array do
  it 'accepts a content type' do
    array_of_numbers = Camille::Types::Array.new(Camille::Types::Number.new)
    expect(array_of_numbers.content).to be_an_instance_of(Camille::Types::Number)
  end

  it 'accepts a hash as content' do
    array_of_objects = Camille::Types::Array.new(
      id: Camille::Types::Number.new
    )
    expect(array_of_objects.content).to be_an_instance_of(Camille::Types::Object)
    expect(array_of_objects.content.fields[:id]).to be_an_instance_of(Camille::Types::Number)
  end

end
