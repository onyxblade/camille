module Camille
  module Types
    class Union < Camille::BasicType
      attr_reader :left, :right

      def initialize left, right
        @left = Camille::Type.instance left
        @right = Camille::Type.instance right
      end

      def transform_and_check value
        left_error, left_transformed = @left.transform_and_check value
        if left_error
          right_error, right_transformed = @right.transform_and_check value
          if right_error
            error = Camille::TypeError.new(
              'union.left' => right_error,
              'union.right' => right_error
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