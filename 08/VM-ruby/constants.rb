module VM
  C_ARITHMETIC = 1
  C_PUSH       = 2
  C_POP        = 3
  C_LABEL      = 4
  C_GOTO       = 5
  C_IF_GOTO    = 6
  C_FUNCTION   = 7
  C_RETURN     = 8
  C_CALL       = 9

  COMMAND_TYPES = {
    'push' => C_PUSH,
    'pop'  => C_POP,
    'label' => C_LABEL,
    'goto'  => C_GOTO,
    'if-goto' => C_IF_GOTO,
    'function' => C_FUNCTION,
    'return' => C_RETURN,
    'call' => C_CALL,
  }

  POINTER_MAP = {
    'local' => 'LCL',
    'argument' => 'ARG',
    'this' => 'THIS',
    'that' => 'THAT',
    'temp' => 5,
    '0' => 'THIS',
    '1' => 'THAT',
  }

  CALCULATIONS = {
    'add' => 'M+D',
    'sub' => 'M-D',
    'eq'  => 'JEQ',
    'gt'  => 'JGT',
    'lt'  => 'JLT',
    'and' => 'D&M',
    'or'  => 'D|M',
  }

  Command = Struct.new(:type, :arg1, :arg2, :command_str)
end
