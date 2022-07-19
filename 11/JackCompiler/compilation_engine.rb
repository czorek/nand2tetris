require_relative './utils.rb'
require_relative './symbol_table.rb'

module Jack
  class CompilationEngine
    include Utils

    class SyntaxError < StandardError; end
    class IdentifierUndefinedError < StandardError; end

    def initialize(tokenizer, output_file)
      @tokenizer = tokenizer
      @current_token = @tokenizer.next_token
      @output_file = output_file
      @class_symbol_table = SymbolTable.new
      @subroutine_symbol_table = SymbolTable::Subroutine.new
      @current_var_type = ""
      @current_subroutine_type = ""
      @class_name = ""
      @current_subroutine = ""
      @arg_count = 0
    end

    def compile_class
      # write_newline_opening_tag(Strings::CLASS)
      process(Strings::CLASS)
      # process_identifier_declaration(Strings::CLASS, Strings::CLASS)
      process_class_name
      process(Strings::C_BRACKET_L)
      compile_class_var_dec
      compile_subroutines
      process(Strings::C_BRACKET_R)
    rescue StopIteration
      return
      # write_closing_tag(Strings::CLASS)
    end

    private
    attr_reader :tokenizer, :output_file, :current_token, :class_symbol_table, :subroutine_symbol_table,
                :current_var_type, :class_name, :current_subroutine, :current_subroutine_type, :arg_count

    def process_class_name
      @class_name = current_token.value
      advance
    end

    def process_subroutine_name
      @current_subroutine = current_token.value
      advance
    end

    def compile_class_var_dec
      return unless Strings::CLASS_VAR_DEC_KWDS.include? current_token.value

      process(*Strings::CLASS_VAR_DEC_KWDS)
      @current_var_type = process_type(*Strings::VAR_TYPES)
      process_identifier_list(Strings::CLASS)

      compile_class_var_dec
    end

    def compile_var_dec
      return unless Strings::VAR == current_token.value

      write_newline_opening_tag(Strings::VAR_DEC)
      process(*Strings::VAR)
      @current_var_type = process_type(*Strings::VAR_TYPES)
      process_identifier_list(Strings::LOCAL)
      write_closing_tag(Strings::VAR_DEC)

      compile_var_dec
    end

    def compile_subroutines
      return unless Strings::SUBROUTINE_DEC_KWDS.include? current_token.value

      subroutine_symbol_table.reset

      compile_subroutine_declaration
      compile_subroutine_body

      compile_subroutines
   end

    def compile_subroutine_declaration
      process(*Strings::SUBROUTINE_DEC_KWDS)
      @current_subroutine_type = process_type(*Strings::SUBROUTINE_TYPES)
      # process_identifier_declaration(Strings::SUBROUTINE, Strings::SUBROUTINE)
      process_subroutine_name
      process(Strings::PAREN_L)

      process_parameter_list
      process(Strings::PAREN_R)
   end

    def compile_subroutine_body
      process(Strings::C_BRACKET_L)
      compile_var_dec

      write_subroutine_declaration
      compile_statements

      process(Strings::C_BRACKET_R)

      return unless current_subroutine_type == Strings::VOID

      output_file.write "push constant 0\nreturn\n"
    end

    def write_subroutine_declaration
      line = "function #{class_name}.#{current_subroutine} #{subroutine_symbol_table.var_count(Strings::LOCAL)}\n"
      output_file.write line
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

    def process_identifier_declaration(var_kind = "", type = "")
      if not is_number? current_token.value[0]
        symbol_table = var_kind == Strings::CLASS ? class_symbol_table : subroutine_symbol_table

        if type.empty?
          type = current_var_type
        end

        symbol_table.define_var(name: current_token.value, type: type, kind: var_kind)

        var = symbol_table.fetch(current_token.value)

        str = <<~STR
        <name>#{var.name}</name>
        <category>#{var.kind}</category>
        <index>#{var.idx}</index>
        <declaration/>
        STR

        output_file.write str

        advance
      else
        msg = "Syntax error! Identifier cannot start with a digit: #{current_token.value}\n"
        raise_syntax_error(msg)
      end
    end

    def process_identifier_usage(var_kind = "")
      var_name = current_token.value

      if not is_number? var_name[0]
        var = subroutine_symbol_table.fetch(var_name) || class_symbol_table.fetch(var_name)
        name = var&.name
        kind = var&.kind
        index = var&.idx

        unless var
          if var_name[0] == var_name[0].upcase
            name = var_name
            kind = Strings::CLASS
            index = 0
          elsif var_kind == Strings::SUBROUTINE
            name = var_name
            kind = var_kind
            index = 0
          else
            msg = "Syntax error! Identifier cannot start with a digit: #{current_token.value}\n"
            raise_syntax_error(msg)
          end
        end

        str = <<~STR
        <name>#{name}</name>
        <category>#{kind}</category>
        <index>#{index}</index>
        <usage/>
        STR
        # output_file.write str

        advance
      else
     end
    end

    def process_identifier_list(var_kind = "")
      process_identifier_declaration(var_kind)

      if current_token.value == Strings::COMMA
        process(Strings::COMMA)
        process_identifier_list(var_kind)
      else
        process(Strings::SEMICOLON)
      end
    end

    def process_parameter_list
      return if current_token.value == Strings::PAREN_R

      @current_var_type = process_type(*Strings::VAR_TYPES)

      process_identifier_declaration(Strings::ARGUMENT)

      if current_token.value == Strings::COMMA
        process(Strings::COMMA)
        process_parameter_list
      end
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
      process_identifier_usage(Strings::LOCAL)

      if Strings::BRACKET_L == current_token.value
        compile_array_index_expr
      end

      process(Strings::EQ)
      compile_expression
      process(Strings::SEMICOLON)

      write_closing_tag(Strings::LET_STATEMENT)
    end

    def compile_do
      # write_newline_opening_tag(Strings::DO_STATEMENT)
      process(Strings::DO)
      # compile_subroutine_call
      compile_expression
      process(Strings::SEMICOLON)
      # write_closing_tag(Strings::DO_STATEMENT)
      output_file.write "pop temp 0\n"
    end

    def compile_return
      # write_newline_opening_tag(Strings::RETURN_STATEMENT)
      process(Strings::RETURN)

      unless Strings::SEMICOLON == current_token.value
        compile_expression
      end

      process(Strings::SEMICOLON)
      # write_closing_tag(Strings::RETURN_STATEMENT)
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
      compile_term

      if current_token.type == TokenType::SYMBOL && Strings::OPERATORS.include?(current_token.value)
        line = "#{Strings::VM_OPERATORS[current_token.value]}\n"
        advance
        compile_term
        output_file.write line
      end
    end

    def compile_term
      type = current_token.type
      case type
      when TokenType::INT_CONST
        line = "push constant #{current_token.value}\n"
        output_file.write line
        advance
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
    end

    def compile_expression_with_symbol
      if Strings::UNARY_OPERATORS.include? current_token.value
        line = "#{current_token.value}\n"
        advance
        compile_term

        output_file.write line
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
        process_identifier_usage
        compile_array_index_expr
      else
        process_identifier_usage
      end
    end

    def compile_expression_list
      return if current_token.value == Strings::PAREN_R

      compile_expression
      @arg_count += 1
      if current_token.value == Strings::COMMA
        process(Strings::COMMA)
        compile_expression_list
      end
    end

    def compile_subroutine_call
      line = ""
      line << current_token.value

      process_identifier_usage

      if Strings::DOT == current_token.value
        process(Strings::DOT)
        line << ".#{current_token.value}"
        process_identifier_usage(Strings::SUBROUTINE)
      end

      process(Strings::PAREN_L)
      @arg_count = 0
      compile_expression_list
      process(Strings::PAREN_R)

      unless line.index('.')
        line.prepend("#{class_name}.")
      end
      line.prepend("call ")
      line << " #{arg_count}\n"

      output_file.write line
    end

    def process(*strings)
      if strings.include? current_token.value
        advance
        #print_and_advance
      else
        msg = "Syntax error! current token: #{current_token.value}, expected string: #{strings}\n"
        raise_syntax_error(msg)
      end
    end

    def process_type(*var_types)
      # @current_var_type = current_token.value
      type = current_token.value

      if current_token.type == TokenType::IDENTIFIER
        process_identifier_usage
      else
        process(*var_types)
      end
      type
    end

    def print_and_advance
      # type = TOKEN_TYPES_MAP[current_token.type]
      # line = opening_tag(type) + token_value + closing_tag(type)

      # output_file.write line
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

    def write_and_advance(line)
      output_file.write line
      advance
    end

    def advance
      @current_token = tokenizer.next_token
    end

    def raise_syntax_error(msg)
      raise SyntaxError.new(msg)
    end

    def raise_undefined
      raise IdentifierUndefinedError.new("Undefined identifier: #{current_token.value}")
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