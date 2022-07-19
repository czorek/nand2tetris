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
end
