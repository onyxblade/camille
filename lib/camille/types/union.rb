module Camille
  module Types
    class Union < Camille::BasicType
      attr_reader :left, :right

      def initialize left, right
        @left = Camille::Type.instance left
        @right = Camille::Type.instance right
      end

      def check value
        left_result = @left.check value
        if left_result
          right_result = @right.check value
          if right_result
            Camille::TypeError.new(
              'union.left' => left_result,
              'union.right' => right_result
            )
          end
        end
      end

      def transform_and_check value
        left_transformed = @left.transform value
        left_result = @left.check left_transformed
        if left_result
          right_transformed = @right.transform value
          right_result = @right.check right_transformed
          if right_result
            error = Camille::TypeError.new(
              'union.left' => left_result,
              'union.right' => right_result
            )
            [error, nil]
          else
            [nil, right_transformed]
          end
        else
          [nil, left_transformed]
        end
      end

      def literal
        "#{@left.literal} | #{@right.literal}"
      end
    end
  end
end