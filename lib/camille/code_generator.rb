require 'stringio'

module Camille
  module CodeGenerator
    def self.generate_ts
      io = StringIO.new
      io.puts Camille::Configuration.ts_header
      io.puts
      Camille::Types.literal_lines.each do |line|
        io.puts "export #{line}"
      end
      io.puts
      io.print "export default "
      Camille::Schemas.literal_lines.each do |line|
        io.puts line
      end
      io.string
    end

    def self.generate_ts_file
      if Camille::Configuration.ts_location
        File.open(Camille::Configuration.ts_location, 'w'){|f| f.write generate_ts}
      end
    end
  end
end