module Camille
  module Types
    class Array < Camille::Type
      attr_reader :content_type

      def initialize content_type
        @content_type = content_type
      end
    end
  end
end