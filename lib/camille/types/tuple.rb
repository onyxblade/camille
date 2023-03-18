module Camille
  module Types
    class Tuple < Camille::BasicType
      attr_reader :elements

      def initialize elements
        @elements = elements.map{|e| Camille::Type.instance e}
      end

      def transform_and_check value
        if value.is_a? ::Array
          transform_and_check_results = @elements.map.with_index do |type, index|
            [index, type.transform_and_check(value[index])]
          end

          errors = transform_and_check_results.map do |index, (error, transformed)|
            ["tuple[#{index}]", error]
          end.select{|x| x[1]}

          if errors.empty?
            transformed = transform_and_check_results.map{|index, (error, transformed)| transformed}
            [nil, transformed]
          else
            [Camille::TypeError.new(**errors.to_h), nil]
          end
        else
          [Camille::TypeError.new("Expected array, got #{value.inspect}."), nil]
        end
      end

      def literal
        "[#{elements.map(&:literal).join(', ')}]"
      end
    end
  end
end