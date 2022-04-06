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
      write_newline_opening_tag(Strings::CLASS)
      process(Strings::CLASS)
      process_identifier
      process(Strings::C_BRACKET_L)
      compile_class_var_dec
      compile_subroutines
      process(Strings::C_BRACKET_R)
    rescue StopIteration
      write_closing_tag(Strings::CLASS)
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

      write_newline_opening_tag(Strings::CLASS_VAR_DEC)
      process(*Strings::CLASS_VAR_DEC_KWDS)
      process_type(*Strings::VAR_TYPES)
      process_identifier_list
      write_closing_tag(Strings::CLASS_VAR_DEC)

      compile_class_var_dec
    end

    def compile_var_dec
      return unless Strings::VAR == current_token.value

      write_newline_opening_tag(Strings::VAR_DEC)
      process(*Strings::VAR)
      process_type(*Strings::VAR_TYPES)
      process_identifier_list
      write_closing_tag(Strings::VAR_DEC)

      compile_var_dec
    end

    def compile_subroutines
      return unless Strings::SUBROUTINE_DEC_KWDS.include? current_token.value

      write_newline_opening_tag(Strings::SUBROUTINE_DEC)
      compile_subroutine_declaration
      compile_subroutine_body
      write_closing_tag(Strings::SUBROUTINE_DEC)

      compile_subroutines
   end

    def compile_subroutine_declaration
      process(*Strings::SUBROUTINE_DEC_KWDS)
      process_type(*Strings::SUBROUTINE_TYPES)
      process_identifier
      process(Strings::PAREN_L)

      write_newline_opening_tag(Strings::PARAMETER_LIST)
      process_parameter_list
      write_closing_tag(Strings::PARAMETER_LIST)
      process(Strings::PAREN_R)
    end

    def compile_subroutine_body
      write_newline_opening_tag(Strings::SUBROUTINE_BODY)
      process(Strings::C_BRACKET_L)
      compile_var_dec

      write_newline_opening_tag(Strings::STATEMENTS)
      compile_statements
      write_closing_tag(Strings::STATEMENTS)

      process(Strings::C_BRACKET_R)
      write_closing_tag(Strings::SUBROUTINE_BODY)
    end

    def compile_statements
      case current_token.value
      when Strings::IF
        compile_if
      when Strings::WHILE
        compile_while
      when Strings::LET
        compile_let
      when Strings::DO
        compile_do
      when Strings::RETURN
        compile_return
      else
        return
        msg = "SyntaxError! You need at least a return statement."
        raise_syntax_error(msg)
      end

      compile_statements
    end

    def compile_if
      write_newline_opening_tag(Strings::IF_STATEMENT)
      process(Strings::IF)

      compile_statement_expression
      compile_statement_body

      if Strings::ELSE == current_token.value
        process(Strings::ELSE)
        compile_statement_body
      end

      write_closing_tag(Strings::IF_STATEMENT)
    end

    def compile_while
      write_newline_opening_tag(Strings::WHILE_STATEMENT)
      process(Strings::WHILE)
      compile_statement_expression
      compile_statement_body
      write_closing_tag(Strings::WHILE_STATEMENT)
    end

    def compile_let
      write_newline_opening_tag(Strings::LET_STATEMENT)
      process(Strings::LET)
      process_identifier

      if Strings::BRACKET_L == current_token.value
        compile_array_index_expr
      end

      process(Strings::EQ)
      compile_expression
      process(Strings::SEMICOLON)

      write_closing_tag(Strings::LET_STATEMENT)
    end

    def compile_do
      write_newline_opening_tag(Strings::DO_STATEMENT)
      process(Strings::DO)
      compile_subroutine_call
      process(Strings::SEMICOLON)
      write_closing_tag(Strings::DO_STATEMENT)
    end

    def compile_return
      write_newline_opening_tag(Strings::RETURN_STATEMENT)
      process(Strings::RETURN)

      unless Strings::SEMICOLON == current_token.value
        compile_expression
      end

      process(Strings::SEMICOLON)
      write_closing_tag(Strings::RETURN_STATEMENT)
    end

    def compile_statement_expression
      process(Strings::PAREN_L)
      compile_expression
      process(Strings::PAREN_R)
    end

    def compile_statement_body
      process(Strings::C_BRACKET_L)
      write_newline_opening_tag(Strings::STATEMENTS)
      compile_statements
      write_closing_tag(Strings::STATEMENTS)
      process(Strings::C_BRACKET_R)
    end

    def compile_array_index_expr
      process(Strings::BRACKET_L)
      compile_expression
      process(Strings::BRACKET_R)
    end

    def compile_expression
      write_newline_opening_tag(Strings::EXPRESSION)
      compile_term

      if current_token.type == TokenType::SYMBOL && Strings::OPERATORS.include?(current_token.value)
        process(*Strings::OPERATORS)
        compile_term
      end

      write_closing_tag(Strings::EXPRESSION)
    end

    def compile_term
      write_newline_opening_tag(Strings::TERM)
      type = current_token.type
      case type
      when TokenType::INT_CONST
        print_and_advance
      when TokenType::STRING_CONST
        print_and_advance
      when TokenType::KEYWORD
        if Strings::EXPR_KWDS.include? current_token.value
          print_and_advance
        else
          msg = "SyntaxError! Unpermitted keyword in expression"
          raise_syntax_error(msg)
        end
      when TokenType::SYMBOL
        compile_expression_with_symbol
      when TokenType::IDENTIFIER
        compile_expression_with_identifier
      end
      write_closing_tag(Strings::TERM)
    end

    def compile_expression_with_symbol
      if Strings::UNARY_OPERATORS.include? current_token.value
        process(*Strings::UNARY_OPERATORS)
        compile_term
      elsif Strings::PAREN_L == current_token.value
        process(Strings::PAREN_L)
        compile_expression
        process(Strings::PAREN_R)
      else
        msg = "SyntaxError! Unpermitted token in expression."
        raise_syntax_error(msg)
      end
    end

    def compile_expression_with_identifier
      next_token = tokenizer.peek_token

      if Strings::SUBROUTINE_CALL_SYMBOLS.include? next_token.value
        compile_subroutine_call
      elsif Strings::BRACKET_L == next_token.value
        process_identifier
        compile_array_index_expr
      else
        process_identifier
      end
    end

    def compile_expression_list
      return if current_token.value == Strings::PAREN_R

      compile_expression

      if current_token.value == Strings::COMMA
        process(Strings::COMMA)
        compile_expression_list
      end
    end

    def compile_subroutine_call
      process_identifier

      if Strings::DOT == current_token.value
        process(Strings::DOT)
        process_identifier
      end

      process(Strings::PAREN_L)
      write_newline_opening_tag(Strings::EXPRESSION_LIST)
      compile_expression_list
      write_closing_tag(Strings::EXPRESSION_LIST)
      process(Strings::PAREN_R)
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

    def write_opening_tag(str)
      output_file.write opening_tag str
    end

    def write_closing_tag(str)
      output_file.write closing_tag str
    end

    def write_newline_opening_tag(str)
      line = opening_tag(str) + "\n"
      output_file.write line
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