require './constants.rb'
require 'pry'

module Jack
  class Tokenizer
    Token = Struct.new(:value, :type)

    def initialize(jack_file)
      str = IO.read(jack_file)
      str.gsub!(COMMENT_REGEX, '') # strip comments

      captures = str.scan(GRAMMAR_REGEX)

      tokens = captures.flatten.map do |string|
        Token.new(string, token_type(string))
      end

      @tokens = tokens.each # enumerator
    end

    def next_token
      tokens.next
    end

    def peek_token
      tokens.peek
    end

    def has_more_tokens?
      tokens.peek rescue false
    end

    private
    attr_reader :tokens

    def token_type(string)
      if KEYWORDS.include? string
        KEYWORD
      elsif SYMBOLS.include? string
        SYMBOL
      elsif is_number? string
        INT_CONST
      elsif string.start_with? '"'
        STRING_CONST
      else
        IDENTIFIER
      end
    end

    def is_number?(string)
      Float(string) != nil rescue false
    end
  end
end