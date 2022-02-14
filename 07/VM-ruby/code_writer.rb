require_relative './constants.rb'

module VM
  class CodeWriter
    def initialize(filename)
      @filename = filename
      @static_pointer = 16
    end

    def write(command)
      case command.type
      when C_PUSH
        write_push(command)
      when C_POP
        write_pop(command)
      when C_ARITHMETIC
        write_arithmetic(command)
      end
    end

    private

    def write_push(command)
      if command.arg1 == 'static'
        write_push_static(command)
      elsif command.arg1 == 'constant'
        write_push_constant(command)
      elsif command.arg1 == 'temp'
        write_push_temp(command)
      elsif command.arg1 == 'pointer'
        write_push_pointer(command)
      else
        write_push_segment(command)
      end
    end

    def write_pop(command)
      if command.arg1 == 'temp'
        write_pop_temp(command)
      elsif command.arg1 == 'static'
        write_pop_static(command)
      elsif command.arg1 == 'pointer'
        write_pop_pointer(command)
      else
        write_pop_segment(command)
      end
    end

    def write_pop_temp(command)
      index = command.arg2

      <<~STR
        // #{command.command_str}
        @#{index}
        D=A
        @5
        D=D+A // address to pop into
        @SP
        AM=M-1
        D=D+M
        A=D-M
        M=D-A\n
     STR
    end

    def write_pop_static(command)
      index = command.arg2

      <<~STR
        // #{command.command_str}
        @#{@filename}.#{index}
        D=A // address to pop into
        @SP
        AM=M-1
        D=D+M
        A=D-M
        M=D-A\n
      STR
    end

    def write_pop_segment(command)
      segment = command.arg1
      index = command.arg2
      segment_pointer = POINTER_MAP.fetch(segment)

      <<~STR
        // #{command.command_str}
        @#{index}
        D=A
        @#{segment_pointer}
        D=D+M // address to pop into
        @SP
        AM=M-1
        D=D+M
        A=D-M
        M=D-A\n
      STR
    end

    def write_pop_pointer(command)
      index = command.arg2
      segment_pointer = POINTER_MAP.fetch(index)

      <<~STR
        // #{command.command_str}
        @#{segment_pointer}
        D=A // address to pop into
        @SP
        AM=M-1
        D=D+M
        A=D-M
        M=D-A\n
      STR
    end

    def write_arithmetic(command)
      calc = CALCULATIONS.fetch(command.arg1)

      <<~STR
        // #{command.command_str}
        @SP
        AM=M-1
        D=M // value from top of stack
        @SP
        A=M-1
        M=#{calc}  // calculation
        \n
      STR
    end

    def write_push_segment(command)
      segment = command.arg1
      index = command.arg2
      segment_pointer = POINTER_MAP.fetch(segment)

      <<~STR
        // #{command.command_str}
        @#{index}
        D=A
        @#{segment_pointer}
        A=D+M // address to push
        D=M // value to push
        @SP
        A=M
        M=D
        @SP
        M=M+1\n
      STR
    end

    def write_push_temp(command)
      index = command.arg2

      <<~STR
        // #{command.command_str}
        @#{index}
        D=A
        @5
        A=D+A // address to push
        D=M // value to push
        @SP
        A=M
        M=D
        @SP
        M=M+1\n
      STR
    end

    def write_push_pointer(command)
      index = command.arg2
      segment_pointer = POINTER_MAP.fetch(index)

      <<~STR
        // #{command.command_str}
        @#{segment_pointer}
        D=M
        @SP
        A=M
        M=D
        @SP
        M=M+1\n
      STR
    end

    def write_push_constant(command)
      value = command.arg2

      <<~STR
        // #{command.command_str}
        @#{value}
        D=A
        @SP
        A=M
        M=D
        @SP
        M=M+1\n
      STR
    end

    def write_push_static(command)
      index = command.arg2

      <<~STR
        // #{command.command_str}
        @#{@filename}.#{index}
        D=M
        @SP
        A=M
        M=D
        @SP
        M=M+1\n
      STR
    end
  end
end
