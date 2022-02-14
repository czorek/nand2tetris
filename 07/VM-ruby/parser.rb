require_relative './constants.rb'

module VM
  class Parser
    Command = Struct.new(:type, :arg1, :arg2, :command_str)

    def parse(vm_line)
      raw_line = vm_line.split('//')[0]&.strip.to_s

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
      if command == 'push'
        C_PUSH
      elsif command == 'pop'
        C_POP
      else
        C_ARITHMETIC
      end
    end

    def infer_args(type, command_parts)
      if type == C_ARITHMETIC
        return command_parts[0], ''
      elsif [C_PUSH, C_POP].include? type
        return command_parts[1], command_parts[2]
      end
    end
  end
end
