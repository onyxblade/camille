module Camille
  module Types
    class Intersection < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      attr_reader :left, :right

      def initialize left, right
        @left = Camille::Type.instance left
        @right = Camille::Type.instance right
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{[@left.fingerprint, @right.fingerprint].sort}"
        @processed_left, @processed_right = Camille::IntersectionPreprocessor.process(@left, @right)
      end

      def check value
        left_result = @processed_left.check value
        if left_result.type_error?
          Camille::TypeError.new(
            'intersection.left' => left_result
          )
        else
          right_result = @processed_right.check left_result.value
          if right_result.type_error?
            Camille::TypeError.new(
              'intersection.right' => right_result
            )
          else
            Camille::Checked.new(fingerprint, right_result.value)
          end
        end
      end

      def literal
        "(#{@left.literal} & #{@right.literal})"
      end

    end
  end
end