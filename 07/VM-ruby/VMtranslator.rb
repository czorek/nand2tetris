require_relative './parser.rb'
require_relative './code_writer.rb'
require_relative './constants.rb'

module VM
  class Translator
    def self.process(vm_filepath)
      vm_file = File.open(vm_filepath, 'r')
      output_filename = extract_filename(vm_filepath)
      output_file = File.open("#{File.dirname(vm_file.path)}/#{output_filename}.asm", "w")

      parser = Parser.new
      codewriter = CodeWriter.new(output_filename)

      vm_lines = vm_file.readlines.map(&:chomp)

      vm_lines.each do |vm_line|
        command = parser.parse(vm_line)

        if command
          code = codewriter.write(command)
          output_file.write("#{code.chomp}")
        end
      end

      output_file.write(end_loop)
    end

    private

    def self.extract_filename(path)
      path.split('/').last.split('.').first
    end

    def self.end_loop
      <<~STR
      (END)
        @END
        0;JMP
      STR
    end
  end
end

ARGV.each do |a|
  VM::Translator.process(a)
end
