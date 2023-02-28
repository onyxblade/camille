module Camille
  module Types
    class Array < Camille::Type
      attr_reader :content

      def initialize content_type
        @content = content_type
      end
    end
  end
end