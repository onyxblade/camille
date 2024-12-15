module Camille
  module Types
    class Intersection < Camille::BasicType
      class ArgumentError < ::ArgumentError; end

      attr_reader :left, :right

      def initialize left, right
        @left = Camille::Type.instance left
        @right = Camille::Type.instance right
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{[@left.fingerprint, @right.fingerprint].sort}"
        @processed_object = Camille::IntersectionSolver.solve(@left, @right)
      end

      def check value
        @processed_object.check value
      end

      def literal
        "(#{@left.literal} & #{@right.literal})"
      end

    end
  end
end