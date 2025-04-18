using Camille::Syntax

class Camille::Types::DateTime < Camille::Type
  include Camille::Types

  alias_of(String)

  def transform value
    value.as_json
  end

  def check value
    normalized = transform value
    super normalized
  end
end