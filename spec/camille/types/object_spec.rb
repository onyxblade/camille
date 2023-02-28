
RSpec.describe Camille::Types::Object do
  it 'accepts a hash of fields' do
    object = Camille::Types::Object.new(
      id: Camille::Types::Number.new,
      name: Camille::Types::String.new
    )
    expect(object.fields[:id]).to be_an_instance_of(Camille::Types::Number)
    expect(object.fields[:name]).to be_an_instance_of(Camille::Types::String)
  end

  it 'deeply converts hash fields to objects' do
    object = Camille::Types::Object.new(
      product: {
        id: Camille::Types::Number.new,
        price: {
          regular: Camille::Types::Number.new,
        }
      }
    )

    expect(object.fields[:product]).to be_an_instance_of(Camille::Types::Object)
    expect(object.fields[:product].fields[:price]).to be_an_instance_of(Camille::Types::Object)
    expect(object.fields[:product].fields[:price].fields[:regular]).to be_an_instance_of(Camille::Types::Number)
  end

end
