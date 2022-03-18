require_relative './constants.rb'

module VM
  module ArithmeticWriter
    def write_arithmetic(command, line_count=0)
      case command.arg1
      when 'add', 'sub'
        write_add_or_sub(command)
      when 'and', 'or'
        write_and_or(command)
      when 'neg'
        write_neg(command)
      when 'not'
        write_not(command)
      when 'lt', 'eq', 'gt'
        write_eq_lt_gt(command, line_count)
      end
    end

    def write_add_or_sub(command)
      calc = CALCULATIONS.fetch(command.arg1)

      <<~STR
        @SP // #{command.command_str}
        AM=M-1
        D=M // value from top of stack
        @SP
        A=M-1
        M=#{calc}  // calculation
        \n
      STR
    end

    def write_and_or(command)
      calc = CALCULATIONS.fetch(command.arg1)

      <<~STR
        @SP // #{command.command_str}
        AM=M-1
        D=M // value from top of stack
        @SP
        A=M-1
        M=#{calc}  // calculation
        \n
      STR
    end

    def write_eq_lt_gt(command, line_count)
      jump = CALCULATIONS.fetch(command.arg1)

      <<~STR
        @SP // #{command.command_str}
        AM=M-1
        D=M // value from top of stack
        @SP
        A=M-1
        D=M-D // 0?
        M=-1  // true
        @TRUE.#{line_count}
        D;#{jump}
        @SP
        A=M-1
        M=0 // false
        (TRUE.#{line_count})
        \n
      STR
    end

    def write_neg(command)
      <<~STR
        @SP // #{command.command_str}
        A=M-1
        M=-M
        \n
      STR
    end

    def write_not(command)
      <<~STR
        @SP // #{command.command_str}
        A=M-1
        M=!M
        \n
      STR
    end
  end
end
