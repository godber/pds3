/*****************************************************************************
 * ANTLR v4 implementation of ODLv2 as defined here:
 *      http://pds.nasa.gov/documents/sr/Chapter12.pdf
 * Work in progress.
 *****************************************************************************/

grammar ODLv21;

label
  : (statement|COMMENT|NEWLINE)* ('END'|'end')
  ;

statement
  : (namespace_identifier)? assignment_stmt (COMMENT)* NEWLINE
  ;

assignment_stmt
  : IDENTIFIER '=' value
  ;

// I am not sure this is necessary, should these just be included in the value
// rule?
symbolic_value
  : IDENTIFIER
  | SYMBOL_STRING
  ;

value
  : STRING
  | INTEGER (units_expression)?
  | FLOAT (units_expression)?
  | symbolic_value
  ;

units_expression
  : '<' IDENTIFIER '>'
  ;

namespace_identifier
  : IDENTIFIER ':'
  ;

IDENTIFIER
  : [A-Za-z][A-Za-z0-9'_']*[A-Za-z0-9]*
  ;

// STRING corresponds to quoted_text
// FIXME: Use Lexer Mode to handle formatting inside string
STRING
  : '"' ~["]*? '"'
  ;

// Symbol String 12.3.3.2 or quoted_symbol
SYMBOL_STRING
  : '\'' ~['\r\n\f\v]+? '\''
  ;

INTEGER
  : ('-')? DIGIT+
  ;

// FIXME: Handle valid exponential notation.
FLOAT
  : ('-')? DIGIT+ '.' DIGIT*  // 1.23 1. 1.123123
  | ('-')? '.' DIGIT+         // .1 .123123
  ;

fragment
DIGIT
  : [0-9]
  ;

NEWLINE
  : '\r\n'
  ;

COMMENT
  : '/*' ~[\r\n\f\v]*? '*/'
  ;

WS
  : [ \t]+ -> channel(HIDDEN)
  ;