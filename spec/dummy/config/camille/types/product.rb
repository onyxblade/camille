using Camille::Syntax

class Camille::Types::Product < Camille::Type
  include Camille::Types

  alias_of(**::Product.fields)
end