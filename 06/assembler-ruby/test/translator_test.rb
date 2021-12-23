require 'minitest/autorun'
require_relative '../translator/translator.rb'
require_relative '../parser/parser.rb'
require_relative '../constants.rb'

class TestTranslator < MiniTest::Test
  def setup
    @translator = Assembler::Translator.new
    assembly_file = File.new('./fixtures/sample_assembly.asm', 'r')
    @symbol_table = Assembler::Parser.new.prepare_symbol_table(assembly_file)
  end

  def test_a_instruction_with_decimal
    instruction = Assembler::Parser::Instruction.new(Assembler::A_INSTRUCTION, '12345', false, false, false)
    binary = @translator.to_binary(instruction, @symbol_table)
    assert_equal('0011000000111001', binary)
  end

  def test_a_instruction_with_variable
    instruction = Assembler::Parser::Instruction.new(Assembler::A_INSTRUCTION, 'sum', false, false, false)
    binary = @translator.to_binary(instruction, @symbol_table)
    assert_equal('0000000000010010', binary)
  end

  def test_c_instruction_full
    instruction = Assembler::Parser::Instruction.new(Assembler::C_INSTRUCTION, false, 'DM', 'M+1',  'JLE')
    binary = @translator.to_binary(instruction, @symbol_table)
    assert_equal('1111110111011110', binary)
  end

  def test_c_instruction_no_dest
    instruction = Assembler::Parser::Instruction.new(Assembler::C_INSTRUCTION, false, '', 'D-1', 'JGT')
    binary = @translator.to_binary(instruction, @symbol_table)
    assert_equal('1110001110000001', binary)
  end

  def test_c_instruction_no_jump
    instruction = Assembler::Parser::Instruction.new(Assembler::C_INSTRUCTION, false, 'AM', '-D', '')
    binary = @translator.to_binary(instruction, @symbol_table)
    assert_equal('1110001111101000', binary)
  end

  def test_c_instruction_only_comp
    instruction = Assembler::Parser::Instruction.new(Assembler::C_INSTRUCTION, false, '', 'M-D', '')
    binary = @translator.to_binary(instruction, @symbol_table)
    assert_equal('1111000111000000', binary)
  end
end
