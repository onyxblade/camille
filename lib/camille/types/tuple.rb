module Camille
  module Types
    class Tuple < Camille::BasicType
      attr_reader :elements

      def initialize elements
        @elements = elements.map{|e| Camille::Type.instance e}
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{@elements.map(&:fingerprint)}"
      end

      def check value
        if value.is_a?(::Array) && value.size == @elements.size
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