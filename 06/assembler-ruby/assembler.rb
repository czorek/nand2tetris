require_relative './parser/parser.rb'
require_relative './translator/translator.rb'

module Assembler
  class Main
    def self.process(assembly_path)
      # prepare symbol table
      assembly_file = File.open(assembly_path, 'r')
      parser = Parser.new
      symbol_table = parser.prepare_symbol_table(assembly_file)

      puts symbol_table

      # output file
      filename = extract_filename(assembly_path)
      output_file = File.open("#{filename}.hack", "a")

      assembly_file = File.open(assembly_path, 'r')
      assembly_data = assembly_file.readlines.map(&:chomp)

      assembly_data.each do |line|
        instruction = parser.parse_line(line)

        if instruction
          binary_line = Translator.new.to_binary(instruction, symbol_table) 
          output_file.write("#{binary_line}\n") if binary_line&.length == 16
        end
      end
    end

    private

    def self.extract_filename(assembly_path)
      assembly_path.split('/').last.split('.').first
    end
  end
end
  
ARGV.each do |a|
  Assembler::Main.process(a)
end
