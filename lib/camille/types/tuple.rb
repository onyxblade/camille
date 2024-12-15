module Camille
  module Types
    class Tuple < Camille::BasicType
      attr_reader :elements

      def initialize elements
        @elements = elements.map{|e| Camille::Type.instance e}
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{@elements.map(&:fingerprint)}"
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

      def check value
        if value.is_a?(::Array) && value.size == @elements.size
          transform_and_check_results = @elements.map.with_index do |type, index|
            [index, type.transform_and_check(value[index])]
          end

          results = @elements.map.with_index do |type, index|
            [index, type.check(value[index])]
          end

          errors = results.map do |index, result|
            if result.type_error?
              ["tuple[#{index}]", result]
            else
              nil
            end
          end.compact

          if errors.empty?
            Camille::Checked.new(fingerprint, results.map{|_, checked| checked.value})
          else
            Camille::TypeError.new(**errors.to_h)
          end
        else
          Camille::TypeError.new("Expected array of size #{@elements.size}, got #{value.inspect}.")
        end
      end

      def literal
        "[#{elements.map(&:literal).join(', ')}]"
      end
    end
  end
end