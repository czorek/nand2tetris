require_relative './constants.rb'

module VM
  class Parser

    def parse(vm_line)
      raw_line = strip_whitespace_and_comments(vm_line)

      if is_comment?(raw_line) || is_empty?(raw_line)
        return false
      else
        parts = raw_line.split

        type = infer_command_type(parts[0])
        arg1, arg2 = infer_args(type, parts)

        return Command.new(type, arg1, arg2, raw_line)
      end
    end

    private

    def is_comment?(line)
      line[0] == '/'
    end

    def is_empty?(line)
      line.empty?
    end

    def infer_command_type(command)
      COMMAND_TYPES.fetch(command, C_ARITHMETIC)
    end

    def infer_args(type, command_parts)
      if type == C_ARITHMETIC
        return command_parts[0], ''
      elsif [C_PUSH, C_POP].include? type
        return command_parts[1], command_parts[2]
      elsif [C_LABEL, C_GOTO, C_IF_GOTO].include? type
        return command_parts[1], ''
      elsif type == C_FUNCTION
        return command_parts[1], command_parts[2]
      elsif type == C_RETURN
        return command_parts[0]
      end
    end

    def strip_whitespace_and_comments(vm_line)
      vm_line.split('//')[0]&.strip.to_s
    end
  end
end
