require_relative '../constants.rb'

module Assembler
  class Parser
    Instruction = Struct.new(:type, :symbol, :dest, :comp, :jump)

    def parse_line(raw_line)
      line = raw_line.split('//')[0]&.strip.to_s

      if is_empty?(line) || is_comment?(line)
        return false
      elsif is_label?(line)
        label = line[1..-2]

        return Instruction.new(L_INSTRUCTION, label, false, false, false)
      elsif is_a_instruction?(line)
        value = line[1..-1]

        return Instruction.new(A_INSTRUCTION, value, false, false, false)
      else
        if line.include?('=') && line.include?(';')
          split_line = line.split /[=;]/
          dest = split_line[0]
          comp = split_line[1]
          jump = split_line[2]
        elsif line.include?('=') && !line.include?(';')
          split_line = line.split /[=]/
          dest = split_line[0]
          comp = split_line[1]
          jump = ""
        elsif !line.include?('=') && line.include?(';')
          split_line = line.split /[;]/
          dest = ""
          comp = split_line[0]
          jump = split_line[1]
        else
          dest = ""
          comp = line
          jump = ""
        end
 
        return Instruction.new(C_INSTRUCTION, false, dest, comp, jump)
      end
    end

    def prepare_symbol_table(assembly_file)
      line_count = 0
      next_var_address = 16

      file_data = assembly_file.readlines.map(&:chomp)
      table = BASE_SYMBOL_TABLE.dup

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

      file_data.each do |raw_line|
        line = raw_line.split('//')[0]&.strip.to_s

        if is_a_instruction?(line)
          if contains_variable?(line)
            var_name = line[1..-1]

            unless table.has_key?(var_name)
              table.merge!(var_name => next_var_address) 
              next_var_address += 1
            end
          end
        end
      end

      table
    end

    private

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
