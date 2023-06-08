module Camille
  module Syntax
    module NULL_VALUE; end

    refine ::Hash do
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

      def & other
        Camille::Types::Intersection.new(Camille::Types::Object.new(self), other)
      end
    end

    refine ::Array do
      def [] key = NULL_VALUE
        if key == NULL_VALUE
          Camille::Types::Tuple.new(self)[]
        else
          super
        end
      end

      def | other
        Camille::Types::Union.new(Camille::Types::Tuple.new(self), other)
      end
    end

    refine Integer do
      def [] key = NULL_VALUE
        if key == NULL_VALUE
          Camille::Types::NumberLiteral.new(self)[]
        else
          super
        end
      end

      def | other
        Camille::Types::Union.new(Camille::Types::NumberLiteral.new(self), other)
      end
    end

    refine Float do
      def [] key = NULL_VALUE
        if key == NULL_VALUE
          Camille::Types::NumberLiteral.new(self)[]
        else
          super
        end
      end

      def | other
        Camille::Types::Union.new(Camille::Types::NumberLiteral.new(self), other)
      end
    end

    refine ::String do
      def [] key = NULL_VALUE
        if key == NULL_VALUE
          Camille::Types::StringLiteral.new(self)[]
        else
          super
        end
      end

      def | other
        Camille::Types::Union.new(Camille::Types::StringLiteral.new(self), other)
      end
    end

    refine TrueClass do
      def [] key = NULL_VALUE
        if key == NULL_VALUE
          Camille::Types::BooleanLiteral.new(true)[]
        else
          super
        end
      end

      def | other
        Camille::Types::Union.new(Camille::Types::BooleanLiteral.new(true), other)
      end
    end

    refine FalseClass do
      def [] key = NULL_VALUE
        if key == NULL_VALUE
          Camille::Types::BooleanLiteral.new(false)[]
        else
          super
        end
      end

      def | other
        Camille::Types::Union.new(Camille::Types::BooleanLiteral.new(false), other)
      end
    end
  end
end