module Jack
  class SymbolTable
    VariableEntry = Struct.new(:type, :kind, :idx)
    def initialize
      @table = {}
      @indexes = {
        Strings::STATIC => 0,
        Strings::FIELD => 0,
      }
    end

    def define_var(name:, type:, kind:)
      return if [name, type, kind].any? { |arg| arg.blank? }

      table[name] = VariableEntry.new(type, kind, indexes[kind])
      indexes[kind] += 1
    end

    def fetch(name)
      symbol_table.fetch(name)
    end

    def var_count(var_kind)
      entries.select { |entry| entry.kind == var_kind }.count
    end

    def kind_of(var_name)
      table[var_name].kind
    end

    def type_of(var_name)
      table[var_name].type
    end

    def index_of(var_name)
      table[var_mame].idx
    end

    private
    attr_accessor :table, :indexes

    def entries
      table.values
    end
  end

  class SymbolTable::Subroutine < SymbolTable
    def initialize
      super
      @indexes = {
        Strings::LOCAL => 0,
        Strings::ARG => 0,
      }
    end

    def reset
      indexes.transform_values! { |v| v = 0 }
    end
  end
end