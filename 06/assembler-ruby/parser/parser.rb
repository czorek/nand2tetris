require_relative '../constants.rb'

module Assembler
  class Parser
    Instruction = Struct.new(:type, :symbol, :dest, :comp, :jump)

    def initialize
      @next_var_address = 16
      @table = BASE_SYMBOL_TABLE.dup
    end

    def parse_line(raw_line)
      line = raw_line.split('//')[0]&.strip.to_s

      if is_empty?(line) || is_comment?(line)
        return false
      elsif is_label?(line)
        label = line[1..-2]

        return Instruction.new(L_INSTRUCTION, label, false, false, false)
      elsif is_a_instruction?(line)
        value = line[1..-1]
        
        if contains_variable?(line)
          var_name = value

          unless table.has_key?(var_name)
            table.merge!(var_name => next_var_address) 
            @next_var_address += 1
          end
        end
 
        return Instruction.new(A_INSTRUCTION, value, false, false, false)
      else
        dest, comp, jump = parse_c_instruction(line)
 
        return Instruction.new(C_INSTRUCTION, false, dest, comp, jump)
      end
    end

    def prepare_symbol_table(assembly_file)
      line_count = 0
      file_data = assembly_file.readlines.map(&:chomp)

      file_data.each do |raw_line|
        line = raw_line.split('//')[0]&.strip.to_s

        if is_empty?(line) || is_comment?(line)
          next
        elsif is_label?(line)
          extract_and_save_label(line, table, line_count)

          next
       else
          line_count += 1
        end
      end

      table
    end

    private
    attr_accessor :table, :next_var_address

    def parse_c_instruction(line)
      if line.include?('=') && line.include?(';')
        split_line = line.split /[=;]/

        [split_line[0], split_line[1], split_line[2]]
      elsif line.include?('=') && !line.include?(';')
        split_line = line.split /[=]/

        [split_line[0], split_line[1], ""]
      elsif !line.include?('=') && line.include?(';')
        split_line = line.split /[;]/

        ["", split_line[0], split_line[1]]
      else
        ["", line, ""]
      end
    end

    def extract_and_save_label(line, table, line_count)
      label = line[1..-2]
      table.merge!(label => line_count)
    end

    def is_empty?(line)
      line.empty?
    end

    def is_label?(line)
      line[0] == '('
    end

    def is_comment?(line)
      line[0] == '/'
    end

    def is_a_instruction?(line)
      line[0] == '@'
    end

    def contains_variable?(line)
      line == line.downcase && !(Float(line[1..-1]) != nil rescue false)
    end
  end
end
