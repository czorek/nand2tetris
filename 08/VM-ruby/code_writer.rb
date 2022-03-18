require_relative './constants.rb'
require_relative './push_writer.rb'
require_relative './pop_writer.rb'
require_relative './arithmetic_writer.rb'

module VM
  class CodeWriter
    include PushWriter
    include PopWriter
    include ArithmeticWriter

    def initialize
      @filename = ''
      @static_pointer = 16
      @line_count = 0
      @current_function = ''
    end

    def write(command)
      @line_count += 1

      case command.type
      when C_PUSH
        write_push(command)
      when C_POP
        write_pop(command)
      when C_ARITHMETIC
        write_arithmetic(command, @line_count)
      when C_LABEL
        write_label(command)
      when C_GOTO
        write_goto(command)
      when C_IF_GOTO
        write_if_goto(command)
      when C_FUNCTION
        write_function(command)
      when C_CALL
        write_call_new(command)
      when C_RETURN
        write_return(command)
      end
    end

    def set_filename(filename)
      @filename = filename
    end

    attr_accessor :current_function
    attr_reader   :filename

    def write_label(command)
      label = command.arg1

      unless current_function.empty?
        label = "#{current_function}$#{command.arg1}"
      end

      <<~STR
        // label #{label}
        (#{label})\n
      STR
    end

    def write_goto(command)
      label = command.arg1

      unless current_function.empty?
        label = "#{current_function}$#{command.arg1}"
      end

      <<~STR
        @#{label} // goto #{label}
        D;JMP\n
      STR
    end

    def write_if_goto(command)
      label = command.arg1

      unless current_function.empty?
        label = "#{current_function}$#{command.arg1}"
      end

      <<~STR
        @SP // if-goto #{label}
        AM=M-1
        D=M
        @#{label}
        D;JNE\n
      STR
    end

    def write_function(command)
      function_name = command.arg1
      @current_function = function_name
      local_vars_count = command.arg2.to_i
      init_var_command = Command.new(C_PUSH, 'constant', '0', 'push constant 0')

      str = <<~STR
        (#{function_name}) // function #{function_name}\n
      STR

      local_vars_count.times { |_| str << write_push(init_var_command) }

      str
    end

    def write_return(_command)
      <<~STR
      @returnSubroutine
      0;JMP\n
      STR
    end

    def write_return_subroutine
      <<~STR
      (returnSubroutine) // return
      @LCL // frame = LCL
      D=M
      @frame
      M=D
      @frame // retAddr = *(frame-5)
      D=M
      @5
      A=D-A
      D=M
      @retAddr
      M=D
      @ARG // *ARG = pop()
      D=M
      #{pop_and_decrement_sp}
      @ARG // SP = ARG+1
      D=M+1
      @SP
      M=D
      @frame // THAT = *(frame-1)
      A=M-1
      D=M
      @THAT
      M=D
      @frame // THIS = *(frame-2)
      D=M
      @2
      A=D-A
      D=M
      @THIS
      M=D
      @frame // ARG = *(frame-3)
      D=M
      @3
      A=D-A
      D=M
      @ARG
      M=D
      @frame // LCL = *(frame-4)
      D=M
      @4
      A=D-A
      D=M
      @LCL
      M=D
      @retAddr // goto retAddr
      A=M
      0;JMP\n
      STR
    end

    def write_call_new(command)
      return_label = "#{current_function}$ret.#{@line_count}"
      callee_label = command.arg1
      n_vars = command.arg2

      <<~STR
      // #{command.command_str}
      @#{return_label} //push returnAddress
      D=A
      @returnLabel
      M=D
      @#{n_vars}
      D=A
      @nVars
      M=D
      @#{callee_label}
      D=A
      @calleeLabel
      M=D
      @callSubroutine
      0;JMP
      (#{return_label})\n
      STR
    end

    def write_call_subroutine
      <<~STR
      (callSubroutine)
      @returnLabel //push returnAddress
      D=M
      #{push_and_increment_sp}
      @LCL // push LCL
      D=M
      #{push_and_increment_sp}
      @ARG // push ARG
      D=M
      #{push_and_increment_sp}
      @THIS // push THIS
      D=M
      #{push_and_increment_sp}
      @THAT // push THAT
      D=M
      #{push_and_increment_sp}
      @SP // ARG = SP - 5 - nVars
      D=M
      @5
      D=D-A
      @nVars
      D=D-M
      @ARG
      M=D
      @SP // LCL = SP
      D=M
      @LCL
      M=D
      @calleeLabel
      A=M
      0;JMP
      STR
    end
  end
end
