module Camille
  module Types
    class Array < Camille::Type
      attr_reader :content

      def initialize content_type
        @content = Camille::Type.from_value content_type
      end
    end
  end
end