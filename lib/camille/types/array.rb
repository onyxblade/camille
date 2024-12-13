module Camille
  module Types
    class Array < Camille::BasicType
      attr_reader :content

      def initialize content
        @content = Camille::Type.instance content
        @fingerprint = Digest::MD5.hexdigest "#{self.class.name}#{@content.fingerprint}"
      end

      def transform_and_check value
        if value.is_a? ::Array
          transform_and_check_results = value.map.with_index do |element, index|
            [index, @content.transform_and_check(element)]
          end
          errors = transform_and_check_results.map do |index, (error, transformed)|
            ["array[#{index}]", error]
          end.select{|x| x[1]}

          if errors.empty?
            transformed = transform_and_check_results.map{|_, (_, transformed)| transformed}
            [nil, transformed]
          else
            [Camille::TypeError.new(**errors.to_h), nil]
          end
        else
          [Camille::TypeError.new("Expected array, got #{value.inspect}."), nil]
        end
      end

      def literal
        "#{@content.literal}[]"
      end
    end
  end
end