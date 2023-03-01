module Camille
  module CoreExt
    module NULL_VALUE; end

    refine Hash do
      def [] key = NULL_VALUE
        if key == NULL_VALUE
          Camille::Types::Object.new(self)[]
        else
          super
        end
      end

      def | other
        Camille::Types::Union.new(Camille::Types::Object.new(self), other)
      end
    end
  end
end