using Camille::Syntax

class Camille::Types::DateTime < Camille::Type
  include Camille::Types

  alias_of(String)

  # transforms a DateTime into a String of ISO 8601 format
  def transform value
    value.as_json
  end

  def check value
    normalized = value.as_json
    super normalized
  end
end