lexer grammar RexxLexer;
@lexer::members {
    bool continue;
}

// Comments and unneeded whitespaces will be ignored
COMMENT                     : Comment           -> cnannel(HIDDEN) ;
WHITESPACES                 : Bo                -> channel(HIDDEN) ;

// Symbols
SYM_Ampersand               : '&' ;
SYM_Apostrophe              : '\'';
SYM_Asterisk                : '*' ;
SYM_Bracket_Round_O         : '(' ;
SYM_Bracket_Round_C         : ')' ;
SYM_Colon                   : ':' ;
SYM_Comma                   : ',' ;
SYM_Exclamation             : '!' ;
SYM_Stop                    : '.' ;
SYM_Quotation               : '"' ;
SYM_Semicolon               : ';' ;
SYM_Slash                   : '/' ;
SYM_Backslash               : '\\' ;
SYM_Vertical_bar            : '|' ;
SYM_Plus                    : '+' ;
SYM_Minus                   : '-' ;

// Mathematical operators
OP_Equation                 : '=' ;
OP_Add                      : '+' ;
OP_Sub                      : '-' ;
OP_Mul                      : '*' ;
OP_Power                    : '**' ;
OP_Div                      : '/' ;
OP_Quotinent                : '%' ;
OP_Remainder                : '//' ;
OP_Or                       : '|' ;
OP_Xor                      : '&&' ;
OP_And                      : '&' ;
OP_Not                      : '\\' ;
// Comparison operators
// normal_compare
CMP_Eq                      : '=' ;
CMP_NEq                     : '\\=' ;
CMP_LM                      : '<>' ;
CMP_ML                      : '><' ;
CMP_M                       : '>' ;
CMP_L                       : '<' ;
CMP_MEq                     : '>=' ;
CMP_LEq                     : '<=' ;
CMP_NM                      : '\\>' ;
CMP_NL                      : '\\<' ;
// strict_compare
CMP_Strict_Eq               : '==' ;
CMP_Strict_NEq              : '\\==' ;
CMP_Strict_M                : '>>' ;
CMP_Strict_L                : '<<' ;
CMP_Strict_ME               : '>>=' ;
CMP_Strict_LE               : '<<=' ;
CMP_Strict_NM               : '\\>>' ;
CMP_Strict_NL               : '\\<<' ;

// Keywords
KWD_ADDRESS                 : 'address' ;
KWD_APPEND                  : 'append' ;
KWD_ARG                     : 'arg' ;
KWD_BY                      : 'by' ;
KWD_CALL                    : 'call' ;
KWD_DIGITS                  : 'digits' ;
KWD_DO                      : 'do' ;
KWD_DROP                    : 'drop' ;
KWD_ELSE                    : 'else' ;
KWD_END                     : 'end' ;
KWD_ENGINEERING             : 'engineering' ;
KWD_ERROR                   : 'error' ;
KWD_EXIT                    : 'exit' ;
KWD_EXPOSE                  : 'expose' ;
KWD_FAILURE                 : 'failure' ;
KWD_FOR                     : 'for' ;
KWD_FOREVER                 : 'forever' ;
KWD_FORM                    : 'form' ;
KWD_FUZZ                    : 'fuzz' ;
KWD_HALT                    : 'halt' ;
KWD_IF                      : 'if' ;
KWD_INPUT                   : 'input' ;
KWD_INTERPRET               : 'interpret' ;
KWD_ITERATE                 : 'iterate' ;
KWD_LEAVE                   : 'leave' ;
KWD_LINEIN                  : 'linein' ;
KWD_LOSTDIGITS              : 'lostdigits' ;
KWD_NAME                    : 'name' ;
KWD_NOP                     : 'nop' ;
KWD_NORMAL                  : 'normal' ;
KWD_NOTREADY                : 'notready' ;
KWD_NOVALUE                 : 'novalue' ;
KWD_NUMERIC                 : 'numeric' ;
KWD_OFF                     : 'off' ;
KWD_ON                      : 'on' ;
KWD_OPTIONS                 : 'options' ;
KWD_OTHERWISE               : 'otherwise' ;
KWD_OUTPUT                  : 'output' ;
KWD_PARSE                   : 'parse' ;
KWD_PROCEDURE               : 'procedure' ;
KWD_PULL                    : 'pull' ;
KWD_PUSH                    : 'push' ;
KWD_QUEUE                   : 'queue' ;
KWD_REPLACE                 : 'replace' ;
KWD_RETURN                  : 'return' ;
KWD_SAY                     : 'say' ;
KWD_SCIENTIFIC              : 'scientific' ;
KWD_SELECT                  : 'select' ;
KWD_SIGNAL                  : 'signal' ;
KWD_SOURCE                  : 'source' ;
KWD_STEM                    : 'stem' ;
KWD_STREAM                  : 'stream' ;
KWD_SYNTAX                  : 'syntax' ;
KWD_THEN                    : 'then' ;
KWD_TO                      : 'to' ;
KWD_TRACE                   : 'trace' ;
KWD_UNTIL                   : 'until' ;
KWD_UPPER                   : 'upper' ;
KWD_VALUE                   : 'value' ;
KWD_VAR                     : 'var' ;
KWD_VERSION                 : 'version' ;
KWD_WHEN                    : 'when' ;
KWD_WHILE                   : 'while' ;
KWD_WITH                    : 'with';

// Reserved constant symbols:  .MN, .RESULT, .RC, .RS, or .SIGL
CONST_SYMBOL_RESERVED       : CONST_MN | CONST_RESULT | CONST_RC | CONST_RS CONST_SIGL ;
CONST_MN                    : 'mn' ;
CONST_RESULT                : 'result' ;
CONST_RC                    : 'rc' ;
CONST_RS                    : 'rs' ;
CONST_SIGL                  : 'sigl' ;

// Lexer rules from ANSI referece (optimized)
Digit                       : [0-9] ;
Special                     : SYM_Comma | SYM_Colon | SYM_Semicolon | SYM_Bracket_Round_C | SYM_Bracket_Round_O ;
Not                         : OP_Not | Other_negator ;
Other_negator               : '^' | '¬' ;
Operator_only               : OP_Add | OP_Sub | OP_Quotinent | OP_Or | OP_And | OP_Equation | Not | CMP_M | CMP_L ;
Operator_or_other           : SYM_Slash | SYM_Asterisk ;
Operator_char               : Operator_only | Operator_or_other ;
General_letter              : [_!?A-Za-z] | Extra_letter ;
Extra_letter                : '_' ; // Dummy - just use _ char
Blank                       : ' ' | Other_blank_character ;
Other_blank_character       : [\r\f\t\n\v] ;
Bo                          : Blank* ;
String_or_comment_char      :
                            (
                            Digit
                            |
                            SYM_Stop
                            |
                            Special
                            |
                            Operator_only
                            |
                            General_letter
                            |
                            Blank
                            |
                            Other_character
                            ) ;
Tokenize                    : Between* Tokenbetween* EOF ;
Tokenbetween                : Token Between* ;
Token                       : Operand | Operator | Special ;
Operand                     : String_literal | Var_symbol | Const_symbol ;
Between                     : Comment | Blank_run Blank | EOL ;
Blank_run                   : (Blank | Continuation)+ ;

// TODO: edit lexer rules to omit CONTINUATIONS, but highlight them, if necessary
Continuation                : edit__CONTINUE SYM_Comma (Comment | Blank)* EOL ;
Comment                     :  '/*' Commentpart* SYM_Asterisk* '*/' ;
Commentpart                 : Comment | SYM_Slash* Comment_char+ | SYM_Asterisk+ Comment_char+ ;
Comment_char                : String_or_comment_char | '"' | '\''| EOL ;
string_literal := Hex_string | Binary_string | String
String := quoted_string
Hex_string := quoted_string RADIX ('x' | 'X')
Binary_string := quoted_string RADIX ('b' | 'B')
quoted_string := quotation_mark_string
[(Embedded_quotation_mark
quotation_mark_string)+]
| apostrophe_string
[(Embedded_apostrophe
apostrophe_string)+]
quotation_mark_string := '"' [(string_char | "'")+]
('"' | EOL Msg6.3)
apostrophe_string := "'" [(string_char | '"')+]
("'" | EOL Msg6.2)
string_char := string_or_comment_char | '*' | '/'
Var_symbol := general_letter [var_symbol_char+]
var_symbol_char := general_letter | digit | '.'
Const_symbol := (digit | '.') [const_symbol_char+]
const_symbol_char := var_symbol_char
| EXPONENT_SIGN ('+' | '-')

Special := special
Operator := operator_char | '|' bo '|'
| '/' bo '/' | '*' bo '*' | not bo '='
| '>' bo '<' | '<' bo '>' | '>' bo '='
| not bo '<' | '<' bo '=' | not bo '>'
| '=' bo '=' | not bo '=' bo '='
| '>' bo '>' | '<' bo '<'
| '>' bo '>' bo '='
| not bo '<' bo '<'
| '<' bo '<' bo '='
| not bo '>' bo '>'
| '&' bo '&'
number := plain_number [exponent]
plain_number := ['.'] digit+ | digit+ '.' [digit+]
exponent := ('e' | 'E') ['+' | '-'] digit+
hex_string := (hex_digit [break_hex_digit_pair+]
| [hex_digit hex_digit
[break_hex_digit_pair+]]) | (Msg15.1 |
Msg15.3)
hex_digit := digit | 'a' | 'A' | 'b' | 'B' | 'c'
| 'C' | 'd' | 'D' | 'e' | 'E' | 'f'
| 'F'
break_hex_digit_pair := bo hex_digit hex_digit
binary_string := (binary_digit
[break_binary_digit_quad+]
| binary_digit binary_digit
[break_binary_digit_quad+]
| binary_digit binary_digit
binary_digit
[break_binary_digit_quad+]
| [binary_digit binary_digit
binary_digit binary_digit
[break_binary_digit_quad+]])
| (Msg15.2 | Msg15.4)
binary_digit := '0' | '1'
break_binary_digit_quad := bo binary_digit binary_digit
binary_digit binary_digit