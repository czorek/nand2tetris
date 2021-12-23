require_relative '../constants.rb'

module Assembler
  class Translator
    def to_binary(instruction, symbol_table)
      if instruction.type == A_INSTRUCTION
        symbol = instruction.symbol

        num_string = if contains_variable?(symbol)
          symbol_table.fetch(symbol)
        else
          symbol
        end

        binary_number = num_string.to_i.to_s(2)
        padding = 15 - binary_number.length

        return "#{A_INSTR_PREFIX}#{'0'*padding}#{binary_number}"
      elsif instruction.type == C_INSTRUCTION
        dest = DEST_MAP.fetch(instruction.dest)
        comp = COMP_MAP.fetch(instruction.comp)
        jump = JUMP_MAP.fetch(instruction.jump)

        return "#{C_INSTR_PREFIX}#{comp}#{dest}#{jump}"
      end
    end

    private

    def contains_variable?(value)
      !(Float(value) != nil rescue false)
    end
  end
end
