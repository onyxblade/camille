module Camille
  module Types
    class Tuple < Camille::Type
      attr_reader :elements

      def initialize elements
        @elements = elements.map{|e| Camille::Type.instance e}
      end

      def check value
        if value.is_a? ::Array
          errors = @elements.map.with_index do |type, index|
            ["tuple[#{index}]", type.check(value[index])]
          end.select{|x| x[1]}

          unless errors.empty?
            Camille::TypeError.new(**errors.to_h)
          end
        else
          Camille::TypeError.new("Expected array, got #{value.inspect}.")
        end
      end

    end
  end
end