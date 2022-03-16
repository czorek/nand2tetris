require_relative './constants.rb'
require_relative './push_writer.rb'
require_relative './pop_writer.rb'
require_relative './arithmetic_writer.rb'

module VM
  class CodeWriter
    include PushWriter
    include PopWriter
    include ArithmeticWriter

    def initialize(filename)
      @filename = filename
      @static_pointer = 16
      @line_count = 0
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
      when C_RETURN
        write_return(command)
      end
    end

    def write_label(command)
      label = command.arg1

      <<~STR
        // label #{label}
        (#{label})\n
      STR
    end

    def write_goto(command)
      label = command.arg1

      <<~STR
        // goto #{label}
        @#{label}
        D;JMP
        \n
      STR
    end

    def write_if_goto(command)
      label = command.arg1

      <<~STR
        // if-goto #{label}
        @SP
        AM=M-1
        D=M
        @#{label}
        D;JNE
        \n
      STR
    end

    def write_function(command)
      function_name = command.arg1
      local_vars_count = command.arg2.to_i
      init_var_command = Command.new(C_PUSH, 'constant', '0', 'push constant 0')

      str = <<~STR
        // function #{function_name}
        (#{function_name})
      STR

      local_vars_count.times { |_| str << write_push(init_var_command) }

      str
    end

    def write_return(command)
      <<~STR
      // return
      // frame = LCL
      @LCL
      D=M
      @frame
      M=D
      // retAddr = *(frame-5)
      @frame
      D=M
      @5
      A=D-A
      D=M
      @retAddr
      M=D
      // *ARG = pop()
      @ARG
      D=M
      #{pop_and_decrement_sp}
      // SP = ARG+1
      @ARG
      D=M+1
      @SP
      M=D
      // THAT = *(frame-1)
      @frame
      A=M-1
      D=M
      @THAT
      M=D
      // THIS = *(frame-2)
      @frame
      D=M
      @2
      A=D-A
      D=M
      @THIS
      M=D
      // ARG = *(frame-3)
      @frame
      D=M
      @3
      A=D-A
      D=M
      @ARG
      M=D
      // LCL = *(frame-4)
      @frame
      D=M
      @4
      A=D-A
      D=M
      @LCL
      M=D
      // goto retAddr
      @retAddr
      A=M
      0;JMP
      \n
      STR
    end
  end
end
