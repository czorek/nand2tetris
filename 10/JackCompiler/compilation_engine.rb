require './utils.rb'

module Jack
  class CompilationEngine
    include Utils

    class SyntaxError < StandardError; end

    def initialize(tokenizer, output_file)
      @tokenizer = tokenizer
      @current_token = @tokenizer.next_token
      @output_file = output_file
    end

    def compile_class
      output_file.write(opening_tag(Strings::CLASS) + "\n")
      process(Strings::CLASS)
      process_identifier
      process(Strings::C_BRACKET_L)
      compile_class_var_dec
      compile_subroutines
      process(Strings::C_BRACKET_R)
      output_file.write(closing_tag(Strings::CLASS))
    end

    private
    attr_reader :tokenizer, :output_file, :current_token

    def process_identifier
      if not is_number? current_token.value[0]
        print_and_advance
      else
        msg = "Syntax error! Identifier cannot start with a digit: #{current_token.value}\n"
        raise_syntax_error(msg)
      end
    end

    def process_identifier_list
      process_identifier

      if current_token.value == Strings::COMMA
        process(Strings::COMMA)
        process_identifier_list
      else
        process(Strings::SEMICOLON)
      end
    end

    def process_parameter_list
      return if current_token.value == Strings::PAREN_R

      process_type(*Strings::VAR_TYPES)

      process_identifier

      if current_token.value == Strings::COMMA
        process(Strings::COMMA)
        process_parameter_list
      end
    end

    def compile_class_var_dec
      return unless Strings::CLASS_VAR_DEC_KWDS.include? current_token.value

      output_file.write(opening_tag(Strings::CLASS_VAR_DEC) + "\n")
      process(*Strings::CLASS_VAR_DEC_KWDS)
      process_type(*Strings::VAR_TYPES)
      process_identifier_list
      output_file.write(closing_tag(Strings::CLASS_VAR_DEC))

      compile_class_var_dec
    end

    def compile_var_dec
      return unless Strings::VAR == current_token.value

      output_file.write(opening_tag(Strings::VAR_DEC) + "\n")
      process(*Strings::VAR)
      process_type(*Strings::VAR_TYPES)
      process_identifier_list
      output_file.write(closing_tag(Strings::VAR_DEC))

      compile_var_dec
    end

    def compile_subroutines
      return unless Strings::SUBROUTINE_DEC_KWDS.include? current_token.value

      output_file.write(opening_tag(Strings::SUBROUTINE_DEC) + "\n")
      compile_subroutine_declaration
      compile_subroutine_body
      output_file.write(closing_tag(Strings::SUBROUTINE_DEC) + "\n")

      compile_subroutines
   end

    def compile_subroutine_declaration
      process(*Strings::SUBROUTINE_DEC_KWDS)
      process_type(*Strings::SUBROUTINE_TYPES)
      process_identifier
      process(Strings::PAREN_L)
      output_file.write(opening_tag(Strings::PARAMETER_LIST) + "\n")
      process_parameter_list
      output_file.write(closing_tag(Strings::PARAMETER_LIST) + "\n")
      process(Strings::PAREN_R)
    end

    def compile_subroutine_body
      output_file.write(opening_tag(Strings::SUBROUTINE_BODY))
      process(Strings::C_BRACKET_L)
      compile_var_dec
      compile_statements
      process(Strings::C_BRACKET_R)
      output_file.write(closing_tag(Strings::SUBROUTINE_BODY))
    end

    def compile_statements
      case current_token.value
      when Strings::IF
        compile_if
      when Strings::WHILE
        compile_while
      when Strings::RETURN
        compile_return
      when Strings::LET
        compile_let
      when Strings::DO
        compile_do
      else
        msg = "SyntaxError! Subroutine body needs at least one return statement"
        raise_syntax_error(msg)
      end
    end

    def process(*strings)
      if strings.include? current_token.value
        print_and_advance
      else
        msg = "Syntax error! current token: #{current_token.value}, expected string: #{strings}\n"
        raise_syntax_error(msg)
      end
    end

    def process_type(*var_types)
      if current_token.type == TokenType::IDENTIFIER
        process_identifier
      else
        process(*var_types)
      end
    end

    def print_and_advance
      type = TOKEN_TYPES_MAP[current_token.type]
      line = opening_tag(type) + token_value + closing_tag(type)

      output_file.write line
      advance
    end

    def opening_tag(str)
      "<" + str + ">"
    end

    def closing_tag(str)
      "</" + str + ">" + "\n"
    end

    def advance
      @current_token = tokenizer.next_token
    end

    def raise_syntax_error(msg)
      raise SyntaxError.new(msg)
    end

    def token_value
      string = current_token.value
      type = current_token.type

      if type == TokenType::STRING_CONST
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
  end
end