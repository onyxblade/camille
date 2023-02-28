module Camille
  module Types
    class Union < Camille::Type
      attr_reader :left, :right

      def initialize left, right
        @left = Camille::Type.from_value left
        @right = Camille::Type.from_value right
      end
    end
  end
end