require_relative './parser.rb'
require_relative './code_writer.rb'
require_relative './constants.rb'

module VM
  class Translator
    def initialize
      @parser = Parser.new
      @codewriter = CodeWriter.new
    end

    def process(vm_path)
      output_filename = extract_filename(vm_path)

      if File.directory?(vm_path)
        output_file = File.open("#{vm_path}/#{output_filename}.asm", "w")
        output_file.write(bootstrap)

        vm_files = Dir.children(vm_path).select { |filename| filename.end_with?(VM_EXTENSION) }
        vm_files.each do |filename|
          vm_file = File.open("#{vm_path}/#{filename}", 'r')

          process_file(vm_file, output_file)
        end
      else
        vm_file = File.open(vm_path, 'r')
        output_file = File.open("#{File.dirname(vm_file.path)}/#{output_filename}.asm", "w")

        process_file(vm_file, output_file)
     end

      output_file.write(end_loop)
    end

    private
    attr_reader :parser, :codewriter

    def process_file(vm_file, output_file)
      codewriter.set_filename(extract_filename(vm_file.path))
      vm_lines = vm_file.readlines.compact.map(&:chomp)

      vm_lines.each do |vm_line|
        command = parser.parse(vm_line)

        if command
          code = codewriter.write(command)
          output_file.write("#{code.chomp}")
        end
      end
    end

    def extract_filename(path)
      path.split('/').last.split('.').first
    end

    def end_loop
      <<~STR
      (END)
        @END
        0;JMP
      STR
    end

    def bootstrap
      command = Command.new(C_CALL, "Sys.init", "0", "call Sys.init 0")
      <<~STR
      @256
      D=A
      @SP
      M=D
      #{codewriter.write_call(command)}
      @Sys.init
      0;JMP
      STR
    end
  end
end

ARGV.each do |a|
  VM::Translator.new.process(a)
end
