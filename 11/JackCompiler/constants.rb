module Jack
  GRAMMAR_REGEX = /("[^"]*"|\w+|=|\+|;|\d+|{|}|\(|\)|\[|\]|-|,|\.|"|&|<|>|\/|\*|\||~)/
  COMMENT_REGEX = /^\s*\*.*$|\/{2}.*$|\/\*\*.*$/
  JACK_EXTENSION = '.jack'

  module Strings
    CLASS = 'class'
    CONSTRUCTOR = 'constructor'
    SUBROUTINE = 'subroutine'
    ARG = 'argument'
    LOCAL = 'local'
    FUNCTION = 'function'
    METHOD = 'method'
    FIELD = 'field'
    STATIC = 'static'
    ARGUMENT = 'argument'
    VAR = 'var'
    INT = 'int'
    CHAR = 'char'
    BOOLEAN = 'boolean'
    VOID = 'void'
    TRUE = 'true'
    FALSE = 'false'
    NULL = 'null'
    THIS = 'this'
    LET = 'let'
    DO = 'do'
    IF = 'if'
    ELSE = 'else'
    WHILE = 'while'
    RETURN = 'return'
    ARRAY = 'Array'
    KEYBOARD = 'Keyboard'
    MATH = 'Math'
    MEMORY = 'Memory'
    OUTPUT = 'Output'
    SCREEN = 'Screen'
    STRING = 'String'
    SYS = 'Sys'

    C_BRACKET_L = '{'
    C_BRACKET_R = '}'
    BRACKET_L = '['
    BRACKET_R = ']'
    PAREN_L = '('
    PAREN_R = ')'
    DOT = '.'
    COMMA = ','
    SEMICOLON = ';'
    PLUS = '+'
    MINUS = '-'
    MULTIPLY = '*'
    DIVIDE = '/'
    AND = '&'
    OR = '|'
    LT = '<'
    GT = '>'
    EQ = '='
    NOT = '~'
    NEG = '-'

    OS_CLASSES = [
      ARRAY,
      KEYBOARD,
      MATH,
      MEMORY,
      OUTPUT,
      SCREEN,
      STRING,
      SYS
    ]

    VM_OPERATORS = {
      PLUS => 'add',
      MINUS => 'sub',
      EQ => 'eq' ,
      GT => 'gt' ,
      LT => 'lt' ,
      AND => 'and',
      OR => 'or' ,
      DIVIDE => 'call Math.divide 2',
      MULTIPLY => 'call Math.multiply 2'
    }

    CLASS_VAR_KIND_MAP = {
      FIELD => THIS,
      STATIC => STATIC,
    }

    KEYWORDS = [
      CLASS,
      CONSTRUCTOR,
      FUNCTION,
      METHOD,
      FIELD,
      STATIC,
      VAR,
      INT,
      CHAR,
      BOOLEAN,
      VOID,
      TRUE,
      FALSE,
      NULL,
      THIS,
      LET,
      DO,
      IF,
      ELSE,
      WHILE,
      RETURN,
    ]

    SYMBOLS = [
      C_BRACKET_L,
      C_BRACKET_R,
      BRACKET_L,
      BRACKET_R,
      PAREN_L,
      PAREN_R,
      DOT,
      COMMA,
      SEMICOLON,
      PLUS,
      MINUS,
      MULTIPLY,
      DIVIDE,
      AND,
      OR,
      LT,
      GT,
      EQ,
      NOT,
    ]

    # Arrays of syntax elements permitted in specific places
    CLASS_VAR_DEC_KWDS = [
      STATIC,
      FIELD,
    ]

    VAR_TYPES = [
      INT,
      CHAR,
      BOOLEAN,
    ]

    SUBROUTINE_DEC_KWDS = [
      CONSTRUCTOR,
      FUNCTION,
      METHOD,
    ]

    EXPR_KWDS = {
      TRUE => "push constant 1\nneg\n",
      FALSE => "push constant 0\n",
      NULL => "push constant 0\n",
      THIS => "push pointer 0\n",
    }

    OPERATORS = [
      PLUS,
      MINUS,
      MULTIPLY,
      DIVIDE,
      AND,
      OR,
      LT,
      GT,
      EQ,
    ]

    UNARY_OPERATORS = {
      NEG => 'neg',
      NOT => 'not',
    }

    SUBROUTINE_CALL_SYMBOLS = [
      DOT,
      PAREN_L
    ]

    SUBROUTINE_TYPES = VAR_TYPES << VOID

    QUOTE = '"'

    # Tags
    CLASS_VAR_DEC = 'classVarDec'
    SUBROUTINE_DEC = 'subroutineDec'
    SUBROUTINE_BODY = 'subroutineBody'
    PARAMETER_LIST = 'parameterList'
    EXPRESSION_LIST = 'expressionList'
    EXPRESSION = 'expression'
    TERM = 'term'
    VAR_DEC = 'varDec'
    STATEMENTS = 'statements'
    IF_STATEMENT = 'ifStatement'
    WHILE_STATEMENT = 'whileStatement'
    LET_STATEMENT = 'letStatement'
    DO_STATEMENT = 'doStatement'
    RETURN_STATEMENT = 'returnStatement'
  end

  # token types
  module TokenType
    KEYWORD      = 1
    SYMBOL       = 2
    IDENTIFIER   = 3
    INT_CONST    = 4
    STRING_CONST = 5
  end

  # token types strings
  TOKEN_TYPES_MAP = {
    TokenType::KEYWORD        => 'keyword',
    TokenType::SYMBOL         => 'symbol',
    TokenType::IDENTIFIER     => 'identifier',
    TokenType::INT_CONST      => 'integerConstant',
    TokenType::STRING_CONST   => 'stringConstant',
  }

  CHARACTER_SET = {
    " "=>32,
    "!"=>33,
    "\""=>34,
    "#"=>35,
    "$"=>36,
    "%"=>37,
    "&"=>38,
    "'"=>39,
    "("=>40,
    ")"=>41,
    "*"=>42,
    "+"=>43,
    ","=>44,
    "-"=>45,
    "."=>46,
    "/"=>47,
    "0"=>48,
    "1"=>49,
    "2"=>50,
    "3"=>51,
    "4"=>52,
    "5"=>53,
    "6"=>54,
    "7"=>55,
    "8"=>56,
    "9"=>57,
    ":"=>58,
    ";"=>59,
    "<"=>60,
    "="=>61,
    ">"=>62,
    "?"=>63,
    "@"=>64,
    "A"=>65,
    "B"=>66,
    "C"=>67,
    "D"=>68,
    "E"=>69,
    "F"=>70,
    "G"=>71,
    "H"=>72,
    "I"=>73,
    "J"=>74,
    "K"=>75,
    "L"=>76,
    "M"=>77,
    "N"=>78,
    "O"=>79,
    "P"=>80,
    "Q"=>81,
    "R"=>82,
    "S"=>83,
    "T"=>84,
    "U"=>85,
    "V"=>86,
    "W"=>87,
    "X"=>88,
    "Y"=>89,
    "Z"=>90,
    "["=>91,
    "\\"=>92,
    "]"=>93,
    "^"=>94,
    "_"=>95,
    "`"=>96,
    "a"=>97,
    "b"=>98,
    "c"=>99,
    "d"=>100,
    "e"=>101,
    "f"=>102,
    "g"=>103,
    "h"=>104,
    "i"=>105,
    "j"=>106,
    "k"=>107,
    "l"=>108,
    "m"=>109,
    "n"=>110,
    "o"=>111,
    "p"=>112,
    "q"=>113,
    "r"=>114,
    "s"=>115,
    "t"=>116,
    "u"=>117,
    "v"=>118,
    "w"=>119,
    "x"=>120,
    "y"=>121,
    "z"=>122,
    "{"=>123,
    "|"=>124,
    "}"=>125,
    "~"=>126,
  }
end
