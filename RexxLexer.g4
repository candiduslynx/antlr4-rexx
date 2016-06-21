lexer grammar RexxLexer;

// Comments go to hidden
COMMENT                         :   Comment_              -> channel (HIDDEN) ;
fragment Comment_               :   Comment_S Commentpart*? ( '*' | '/' )*? Comment_E ;
fragment Comment_E              :   '*/' ;
fragment Comment_S              :   '/*' ;
fragment Commentpart            :   ( '/'* | '*'+ ) Comment_char_+
                                |   Comment_
                                ;
fragment Comment_char_          :   String_or_comment_char
                                |   '"'
                                |   '\''
                                |   EOL ;

DELIM                           :   EOS
                                |   SCOL
                                |   EOL
                                ;
fragment EOS                    :   EOF ;
fragment SCOL                   :   ';' ;
fragment EOL                    :   '\n'
                                |   '\r'
                                |   '\n\r'
                                |   '\r\n'
                                ;

// Whitespaces - not so sure
WHITESPACES                     :   DELIM
                                |   WS_+
                                ;
fragment WS_                    :   WS+                  -> channel(HIDDEN) ;
fragment WS                     :   ' '
                                |   '\r'
                                |   '\f'
                                |   '\t'
                                |   '\n'
                                |   '\u000b'
                                ;
// Keywords

KWD_ADDRESS                     :   A D D R E S S ;
KWD_APPEND                      :   A P P E N D ;
KWD_ARG                         :   A R G ;
KWD_BY                          :   B Y ;
KWD_CALL                        :   C A L L ;
KWD_DIGITS                      :   D I G I T S ;
KWD_DO                          :   D O ;
KWD_DROP                        :   D R O P ;
KWD_ELSE                        :   E L S E ;
KWD_END                         :   E N D ;
KWD_ENGINEERING                 :   E N G I N E E R I N G ;
KWD_ERROR                       :   E R R O R ;
KWD_EXIT                        :   E X I T ;
KWD_EXPOSE                      :   E X P O S E ;
KWD_FAILURE                     :   F A I L U R E ;
KWD_FOR                         :   F O R ;
KWD_FOREVER                     :   F O R E V E R ;
KWD_FORM                        :   F O R M ;
KWD_FUZZ                        :   F U Z Z ;
KWD_HALT                        :   H A L T ;
KWD_IF                          :   I F ;
KWD_INPUT                       :   I N P U T ;
KWD_INTERPRET                   :   I N T E R P R E T ;
KWD_ITERATE                     :   I T E R A T E ;
KWD_LEAVE                       :   L E A V E ;
KWD_LINEIN                      :   L I N E I N ;
KWD_LOSTDIGITS                  :   L O S T D I G I T S ;
KWD_NAME                        :   N A M E ;
KWD_NOP                         :   N O P ;
KWD_NORMAL                      :   N O R M A L ;
KWD_NOTREADY                    :   N O T R E A D Y ;
KWD_NOVALUE                     :   N O V A L U E ;
KWD_NUMERIC                     :   N U M E R I C ;
KWD_OFF                         :   O F F ;
KWD_ON                          :   O N ;
KWD_OPTIONS                     :   O P T I O N S ;
KWD_OTHERWISE                   :   O T H E R W I S E ;
KWD_OUTPUT                      :   O U T P U T ;
KWD_PARSE                       :   P A R S E ;
KWD_PROCEDURE                   :   P R O C E D U R E ;
KWD_PULL                        :   P U L L ;
KWD_PUSH                        :   P U S H ;
KWD_QUEUE                       :   Q U E U E ;
KWD_REPLACE                     :   R E P L A C E ;
KWD_RETURN                      :   R E T U R N ;
KWD_SAY                         :   S A Y ;
KWD_SCIENTIFIC                  :   S C I E N T I F I C ;
KWD_SELECT                      :   S E L E C T ;
KWD_SIGNAL                      :   S I G N A L ;
KWD_SOURCE                      :   S O U R C E ;
KWD_STEM                        :   S T E M ;
KWD_STREAM                      :   S T R E A M ;
KWD_SYNTAX                      :   S Y N T A X ;
KWD_THEN                        :   T H E N ;
KWD_TO                          :   T O ;
KWD_TRACE                       :   T R A C E ;
KWD_UNTIL                       :   U N T I L ;
KWD_UPPER                       :   U P P E R ;
KWD_VALUE                       :   V A L U E ;
KWD_VAR                         :   V A R ;
KWD_VERSION                     :   V E R S I O N ;
KWD_WHEN                        :   W H E N ;
KWD_WHILE                       :   W H I L E ;
KWD_WITH                        :   W I T H ;

//-----------------------
VAR_SYMBOL                      :   Var_Symbol_ ;
fragment Var_Symbol_            :   General_letter Var_symbol_char* ;
fragment General_letter         :   [\_\!\?A-Za-z]
                                |   Extra_letter
                                ;
fragment Var_symbol_char        :   General_letter
                                |   Digit_
                                |   '.'
                                ;

OP_Assign                       :   '=' ;
CONST_SYMBOL                    :   Const_symbol_ ;
Const_symbol_                   :   '.' CONST_SYMBOL_RESERVED
                                |   Digit_ Const_symbol_char*
                                ;
// Reserved constant symbols:  .MN, .RESULT, .RC, .RS, or .SIGL
fragment CONST_SYMBOL_RESERVED  :   CONST_MN
                                |   CONST_RESULT
                                |   CONST_RC
                                |   CONST_RS
                                |   CONST_SIGL
                                ;
fragment CONST_MN               :   M N ;
fragment CONST_RESULT           :   R E S U L T ;
fragment CONST_RC               :   R C ;
fragment CONST_RS               :   R S ;
fragment CONST_SIGL             :   S I G L ;
fragment Digit_                 :   [0-9] ;
fragment Const_symbol_char      :   Var_symbol_char
                                |   ('+' | '-')
                                ;
fragment Extra_letter           :   '_' ;   // Dummy
NUMBER                          :   Number_ ;
fragment Number_                :   Plain_number Exponent_? ;
fragment Plain_number           :   '.'? Digit_+
                                |   Digit_+ '.' Digit_*
                                ;
fragment Exponent_              :   E ( '+' | '-' )? Digit_+ ;

Add                             :   '+' ;
Sub                             :   '-' ;
PRE_Not                         :   '\\' ;


OP_Or                           :   '|' ;
OP_Xor                          :   '&&' ;
OP_And                          :   '&' ;
OP_Mul                          :   '*' ;
OP_Div                          :   '/' ;
OP_Quotinent                    :   '//' ;
OP_Remainder                    :   '%' ;
OP_Pow                          :   '**' ;

BR_O                            :   '(' ;
BR_C                            :   ')' ;

CMP_Eq                          :   '=' ;
CMP_NEq                         :   '\\=' ;
CMP_LM                          :   '<>' ;
CMP_ML                          :   '><' ;
CMP_M                           :   '>' ;
CMP_L                           :   '<' ;
CMP_MEq                         :   '>=' ;
CMP_LEq                         :   '<=' ;
CMP_NM                          :   '\\>' ;
CMP_NL                          :   '\\<' ;

CMPS_Eq                         :   '==' ;
CMPS_Neq                        :   '\\==' ;
CMPS_M                          :   '>>' ;
CMPS_L                          :   '<<' ;
CMPS_MEq                        :   '>>=' ;
CMPS_LEq                        :   '<<=' ;
CMPS_NM                         :   '\\>>' ;
CMPS_NL                         :   '\\<<' ;

CONCAT                          :   '||' ;

STRING                          :   String_ ;
fragment String_                :   Quoted_string ;
fragment Quoted_string          :   Quotation_mark_string
                                |   Apostrophe_string
                                ;
fragment Quotation_mark_string  :   '"' (String_char | Embedded_quotation_mark | '\'')* '"' ;
fragment Embedded_quotation_mark:   '""' ;
fragment Apostrophe_string      :   '\'' (String_char | Embedded_apostrophe | '"')* '\'' ;
fragment Embedded_apostrophe    :   '\'\'' ;
fragment String_char            :   String_or_comment_char | '*' | '/' ;
fragment String_or_comment_char :   Digit_
                                |   '.'
                                |   Special
                                |   Operator_only
                                |   General_letter
                                |   Blank
                                |   Other_character
                                ;
fragment Special                :   ','
                                |   ':'
                                |   ';'
                                |   ')'
                                |   '('
                                ;
fragment Blank                  :   ' '
                                |   Other_blank_character
                                ;
fragment Other_blank_character  :   '\r'
                                |   '\f'
                                |   '\t'
                                |   '\n'
                                |   '\u000b'
                                ;
fragment Other_character        :   '_';    // Dummy

fragment Operator_only          :   '+'
                                |   '-'
                                |   '%'
                                |   '|'
                                |   '&'
                                |   '='
                                |   Not_
                                |   '>'
                                |   '<'
                                ;
fragment Not_                   :   '\\'
                                |   Other_negator
                                ;
fragment Other_negator          :   '^'
                                |   '¬'
                                ;
//-----------------------










//Letters are caseless
fragment A                      :   ('a'|'A');
fragment B                      :   ('b'|'B');
fragment C                      :   ('c'|'C');
fragment D                      :   ('d'|'D');
fragment E                      :   ('e'|'E');
fragment F                      :   ('f'|'F');
fragment G                      :   ('g'|'G');
fragment H                      :   ('h'|'H');
fragment I                      :   ('i'|'I');
fragment J                      :   ('j'|'J');
fragment K                      :   ('k'|'K');
fragment L                      :   ('l'|'L');
fragment M                      :   ('m'|'M');
fragment N                      :   ('n'|'N');
fragment O                      :   ('o'|'O');
fragment P                      :   ('p'|'P');
fragment Q                      :   ('q'|'Q');
fragment R                      :   ('r'|'R');
fragment S                      :   ('s'|'S');
fragment T                      :   ('t'|'T');
fragment U                      :   ('u'|'U');
fragment V                      :   ('v'|'V');
fragment W                      :   ('w'|'W');
fragment X                      :   ('x'|'X');
fragment Y                      :   ('y'|'Y');
fragment Z                      :   ('z'|'Z');