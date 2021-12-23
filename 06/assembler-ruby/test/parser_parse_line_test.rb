require 'minitest/autorun'
require_relative '../parser/parser.rb'
require_relative '../constants.rb'

class TestParserParseLine < MiniTest::Test
  def setup
    @parser = Assembler::Parser.new
  end

  def test_label_instruction
    instruction = @parser.parse_line("  (LOOP)")
    assert_equal(instruction.type, Assembler::L_INSTRUCTION)
    assert_equal(instruction.symbol, "LOOP")
  end

  def test_a_instruction_with_decimal
    instruction = @parser.parse_line("@12345")
    assert_equal(instruction.type, Assembler::A_INSTRUCTION)
    assert_equal(instruction.symbol, "12345")
  end

  def test_a_instruction_with_variable
    instruction = @parser.parse_line("@sum")
    assert_equal(instruction.type, Assembler::A_INSTRUCTION)
    assert_equal(instruction.symbol, "sum")
  end

  def test_c_instruction_full
    instruction = @parser.parse_line(" D=A+1;JGT ")
    assert_equal(instruction.type, Assembler::C_INSTRUCTION)
    assert_equal(instruction.symbol, false)
    assert_equal(instruction.dest, "D")
    assert_equal(instruction.comp, "A+1")
    assert_equal(instruction.jump, "JGT")
  end

  def test_c_instruction_no_dest
    instruction = @parser.parse_line(" A+1;JGT ")
    assert_equal(instruction.type, Assembler::C_INSTRUCTION)
    assert_equal(instruction.symbol, false)
    assert_equal(instruction.dest, "")
    assert_equal(instruction.comp, "A+1")
    assert_equal(instruction.jump, "JGT")
  end

  def test_c_instruction_no_jump
    instruction = @parser.parse_line(" A+1 ")
    assert_equal(instruction.type, Assembler::C_INSTRUCTION)
    assert_equal(instruction.symbol, false)
    assert_equal(instruction.dest, "")
    assert_equal(instruction.comp, "A+1")
    assert_equal(instruction.jump, "")
  end
end
