module Camille
  module Types
    class Array < Camille::BasicType
      attr_reader :content

      def initialize content
        @content = Camille::Type.instance content
      end

      def check value
        if value.is_a? ::Array
          errors = value.map.with_index{|e, i| ["array[#{i}]", @content.check(e)]}.select{|x| x[1]}
          unless errors.empty?
            Camille::TypeError.new(**errors.to_h)
          end
        else
          Camille::TypeError.new("Expected array, got #{value.inspect}.")
        end
      end

      def literal
        "#{@content.literal}[]"
      end
    end
  end
end