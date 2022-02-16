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
  end
end
