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

      def check_and_transform value
        left_result = @left.check value
        if left_result
          right_result = @right.check value
          if right_result
            error = Camille::TypeError.new(
              'union.left' => left_result,
              'union.right' => right_result
            )
            [error, nil]
          else
            [nil, @right.transform(value)]
          end
        else
          [nil, @left.transform(value)]
        end
      end

      def literal
        "#{@left.literal} | #{@right.literal}"
      end
    end
  end
end