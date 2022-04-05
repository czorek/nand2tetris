module Jack
  GRAMMAR_REGEX = /("[^"]*"|\w+|=|\+|;|\d+|{|}|\(|\)|\[|\]|-|,|\.|"|&|<|>|\/|\*|\||~)/
  COMMENT_REGEX = /^\s*\*.*$|\/{2}.*$|\/\*\*.*$/

  module Strings
    CLASS = 'class'
    CONSTRUCTOR = 'constructor'
    FUNCTION = 'function'
    METHOD = 'method'
    FIELD = 'field'
    STATIC = 'static'
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
    AMP = '&'
    OR = '|'
    LT = '<'
    GT = '>'
    EQ = '='
    NOT = '~'

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
      AMP,
      OR,
      LT,
      GT,
      EQ,
      NOT,
    ]

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

    SUBROUTINE_TYPES = VAR_TYPES << VOID

    QUOTE = '"'

    # tags
    CLASS_VAR_DEC = 'classVarDec'
    SUBROUTINE_DEC = 'subroutineDec'
    SUBROUTINE_BODY = 'subroutineBody'
    PARAMETER_LIST = 'parameterList'
    VAR_DEC = 'varDec'
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

  # keyword types
  module KeywordType
    CLASS       = 1
    METHOD      = 2
    FUNCTION    = 3
    CONSTRUCTOR = 4
    INT         = 5
    BOOLEAN     = 6
    CHAR        = 7
    VOID        = 8
    VAR         = 9
    STATIC      = 10
    FIELD       = 11
    LET         = 12
    DO          = 13
    IF          = 14
    ELSE        = 15
    WHILE       = 16
    RETURN      = 17
    TRUE        = 18
    FALSE       = 19
    NULL        = 20
    THIS        = 21
  end
end
