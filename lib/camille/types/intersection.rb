module Camille
  module Types
    class Intersection < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      attr_reader :left, :right

      def initialize left, right
        @left = Camille::Type.instance left
        @right = Camille::Type.instance right
      end

      def transform_and_check value
        left_error, left_transformed = @left.transform_and_check value
        if left_error
          error = Camille::TypeError.new(
            'intersection.left' => left_error
          )
          [error, nil]
        else
          right_error, right_transformed = @right.transform_and_check left_transformed
          if right_error
            error = Camille::TypeError.new(
              'intersection.right' => right_error
            )
            [error, nil]
          else
            [nil, right_transformed]
          end
        end
      end

      def literal
        "(#{@left.literal} & #{@right.literal})"
      end

    end
  end
end