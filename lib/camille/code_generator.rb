require 'stringio'

module Camille
  class CodeGenerator
    def initialize types_literal_lines: Camille::Types.literal_lines, schemas_literal_lines: Camille::Schemas.literal_lines
      @types_literal_lines = types_literal_lines
      @schemas_literal_lines = schemas_literal_lines
    end

    def generate_ts
      io = StringIO.new
      generate_header io
      generate_types io
      generate_schemas io
      io.string
    end

    private
      def generate_header io
        io.puts Camille::Configuration.ts_header
        io.puts
      end

      def generate_types io
        @types_literal_lines.each do |line|
          io.puts "export #{line}"
        end
        io.puts
      end

      def generate_schemas io
        io.print "export default "
        @schemas_literal_lines.each do |line|
          io.puts line
        end
      end
  end
end