require './tokenizer.rb'
require './constants.rb'
require './compilation_engine.rb'
require 'pry'

module Jack
  class Analyzer
    JACK_EXTENSION = '.jack'

    def compile(path)
      if File.directory?(path)
        jack_files = Dir.children(path).select { |filename| filename.end_with?(JACK_EXTENSION) }
        puts jack_files

        jack_files.each do |filename|
          puts filename
          jack_file = File.open("#{path}/#{filename}", "r")
          output_file = File.open("#{path}/#{extract_filename(filename)}1.xml", "w")

          process_file(jack_file, output_file)
        end
      else
        jack_file = File.open(path, "r")
        output_file = File.open("#{File.dirname(path)}/#{extract_filename(path)}1.xml", "w")

        process_file(jack_file, output_file)
      end
    end

    private

    def process_file(jack_file, output_file)
      tokenizer = Tokenizer.new(jack_file)
      # produce_tokens_xml(tokenizer, output_file)
      engine = CompilationEngine.new(tokenizer, output_file)

      engine.compile_class
    rescue CompilationEngine::SyntaxError => e
      print e.message
    end

    def produce_tokens_xml(tokenizer, output_file)
      output_file.write(opening_tag("tokens") + "\n")

      while tokenizer.has_more_tokens?
        current_token = tokenizer.next_token
        token_value = get_value(current_token)
        token_type_str = TOKEN_TYPES_MAP[current_token.type]

        output_file.write(
          opening_tag(token_type_str) + token_value.to_s + closing_tag(token_type_str)
        )
      end

      output_file.write(closing_tag("tokens"))
    end

    def get_value(token)
      string = token.value
      type = token.type

      if type == STRING_CONST
        return string[1..-2]
      else
        case string
        when '<'
          '&lt;'
        when '>'
          '&gt;'
        when '"'
          '&quot;'
        when '&'
          '&amp;'
        else
          string
        end
      end
    end

    def opening_tag(string)
      "<" + string + ">"
    end

    def closing_tag(string)
      "</" + string + ">" + "\n"
    end

    def extract_filename(path)
      path.split('/').last.split('.').first
    end
  end
end

ARGV.each do |path|
  Jack::Analyzer.new.compile(path)
end
