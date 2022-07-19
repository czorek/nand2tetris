require_relative './tokenizer.rb'
require_relative './constants.rb'
require_relative './compilation_engine.rb'

module Jack
  class Analyzer
    def compile(path)
      if File.directory?(path)
        jack_files = Dir.children(path).select { |filename| filename.end_with?(JACK_EXTENSION) }
        puts jack_files

        jack_files.each do |filename|
          puts filename
          jack_file = File.open("#{path}/#{filename}", "r")
          output_file = File.open("#{path}/#{extract_filename(filename)}.vm", "w")

          process_file(jack_file, output_file)
        end
      else
        jack_file = File.open(path, "r")
        output_file = File.open("#{File.dirname(path)}/#{extract_filename(path)}.vm", "w")

        process_file(jack_file, output_file)
      end
    end

    private

    def process_file(jack_file, output_file)
      tokenizer = Tokenizer.new(jack_file)
      engine = CompilationEngine.new(tokenizer, output_file)

      engine.compile_class
    rescue CompilationEngine::SyntaxError => e
      print e.message
    end

    def extract_filename(path)
      path.split('/').last.split('.').first
    end
  end
end

ARGV.each do |path|
  Jack::Analyzer.new.compile(path)
end
