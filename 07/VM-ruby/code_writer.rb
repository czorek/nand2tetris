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
      end
    end
  end
end
