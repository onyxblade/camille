module Camille
  module Types
    class Intersection < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      attr_reader :left, :right

      def initialize left, right
        @left = Camille::Type.instance left
        @right = Camille::Type.instance right
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{[@left.fingerprint, @right.fingerprint].sort}"
      end

      def check value
        check_with_method(value, :check)
      end

      def check_params value
        check_with_method(value, :check_params)
      end

      def literal
        "(#{@left.literal} & #{@right.literal})"
      end

      private
        def check_with_method value, method_name
          left_result = @left.public_send(method_name, value)
          if left_result.type_error?
            Camille::TypeError.new(
              'intersection.left' => left_result
            )
          else
            right_result = @right.public_send(method_name, left_result.value)
            if right_result.type_error?
              Camille::TypeError.new(
                'intersection.right' => right_result
              )
            else
              Camille::Checked.new(fingerprint, right_result.value)
            end
          end
        end

    end
  end
end