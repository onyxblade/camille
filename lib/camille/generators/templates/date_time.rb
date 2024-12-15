using Camille::Syntax

class Camille::Types::DateTime < Camille::Type
  include Camille::Types

  alias_of(String)

  # transforms a DateTime into a String of ISO 8601 format
  def transform value
    value.as_json
  end

  def check value
    check_with_fingerprint value do
      if value.is_a? ::Time
        Camille::Checked.new(fingerprint, value.as_json)
      else
        Camille::TypeError.new("Expected DateTime like object, got #{value.inspect}.")
      end
    end
  end
end