module Camille
  module Types
    class Union < Camille::BasicType
      attr_reader :left, :right

      def initialize left, right
        @left = Camille::Type.instance left
        @right = Camille::Type.instance right
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{[@left.fingerprint, @right.fingerprint].sort}"
      end

      def check value
        left_result = @left.check value
        if left_result.type_error?
          right_result = @right.check value
          if right_result.type_error?
            Camille::TypeError.new(
              'union.left' => left_result,
              'union.right' => right_result
            )
          else
            Camille::Checked.new(fingerprint, right_result.value)
          end
        else
          Camille::Checked.new(fingerprint, left_result.value)
        end
      end

      def literal
        "(#{@left.literal} | #{@right.literal})"
      end
    end
  end
end