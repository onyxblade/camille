module Camille
  class Type
    def | other
      Camille::Types::Union.new(self, other)
    end
  end
end