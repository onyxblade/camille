using Camille::Syntax

class Camille::Types::Decimal < Camille::Type
  include Camille::Types

  alias_of(Number)

  def transform value
    if value.is_a? BigDecimal
      value.to_f
    else
      value
    end
  end

  def check value
    normalized = transform value
    super normalized
  end
end