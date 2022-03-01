module VM
  module PopWriter
    def write_pop(command)
      case command.arg1
      when 'temp'
        write_pop_temp(command)
      when 'static'
        write_pop_static(command)
      when 'pointer'
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
        #{pop_and_decrement_sp}
     STR
    end

    def write_pop_static(command)
      index = command.arg2

      <<~STR
        // #{command.command_str}
        @#{@filename}.#{index}
        D=A // address to pop into
        #{pop_and_decrement_sp}
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
        #{pop_and_decrement_sp}
      STR
    end

    def write_pop_pointer(command)
      index = command.arg2
      segment_pointer = POINTER_MAP.fetch(index)

      <<~STR
        // #{command.command_str}
        @#{segment_pointer}
        D=A // address to pop into
        #{pop_and_decrement_sp}
      STR
    end

    def pop_and_decrement_sp
      <<~STR
        @SP
        AM=M-1
        D=D+M
        A=D-M
        M=D-A
        \n
      STR
    end
  end
end

