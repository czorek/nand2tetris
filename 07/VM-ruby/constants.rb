module VM
  C_ARITHMETIC = 1
  C_PUSH       = 2
  C_POP        = 3
  C_LABEL      = 4
  C_GOTO       = 5
  C_IF         = 6
  C_FUNCTION   = 7
  C_RETURN     = 8
  C_CALL       = 9

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
end
