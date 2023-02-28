module Camille
  module Types
    class Union < Camille::Type
      attr_reader :left, :right

      def initialize left, right
        @left, @right = left, right
      end
    end
  end
end