require 'minitest/autorun'
require_relative '../parser/parser.rb'

class TestParserSymbolTable < Minitest::Test
  def setup
    assembly_file = File.new('./fixtures/sample_assembly.asm', 'r')
    @symbol_table = Assembler::Parser.new.prepare_symbol_table(assembly_file)
  end

  def test_table_contains_base_symbols
    assert_includes @symbol_table, 'KBD'
  end

  def test_table_contains_labels
    assert_includes @symbol_table, 'LOOP'
    assert_equal @symbol_table.fetch('LOOP'), 17
  end

  def test_table_contains_variables
    assert_includes @symbol_table, 'sum'
  end
end
