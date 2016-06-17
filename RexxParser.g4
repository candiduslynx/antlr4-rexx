grammar RexxParser;
import RexxLexer;

file                        :   program_ EOF;

/* The first part introduces the overall structure of a program */
program_                    : ncl? instruction_list? ;
  ncl                       : null_clause+ ;
    null_clause             : SYM_Semicolon label_list? ;
      label_list            : ( LABEL SYM_Semicolon )+ ;
  instruction_list          : instruction_+ ;
    instruction_            : group_ | single_instruction ncl ;
single_instruction          : assignment_ | keyword_instruction | command_ ;
  assignment_               : VAR_SYMBOL OP_Equation expression_ ;
  keyword_instruction       :
                            (
                            address_
                            |
                            arg_
                            |
                            call_
                            |
                            drop_
                            |
                            exit_
                            |
                            interpret_
                            |
                            iterate_
                            |
                            leave_
                            |
                            nop_
                            |
                            numeric_
                            |
                            options_
                            |
                            parse_
                            |
                            procedure_
                            |
                            pull_
                            |
                            push_
                            |
                            queue_
                            |
                            return_
                            |
                            say_
                            |
                            signal_
                            |
                            trace_
                            ) ;
  command_                  : expression_ ;
group_                      : do_ | if_ | select_ ;
  do_                       : do_specification ncl instruction_list? do_ending ;
    do_ending               : KWD_END VAR_SYMBOL? ncl ;
  if_                       : KWD_IF expression_ ncl?  then_  else_? ;
    then_                   : KWD_THEN ncl instruction_ ;
    else_                   : KWD_ELSE ncl instruction_ ;
  select_                   : KWD_SELECT ncl select_body KWD_END ncl ;
    select_body             : when_+ otherwise_? ;
  when_                     : KWD_WHEN expression_ ncl? then_ ;
      otherwise_            : KWD_OTHERWISE ncl instruction_list? ;
/*
Note: The next part concentrates on the instructions.
It leaves unspecified the various forms of symbol, template
and expression.
*/
address_                    : KWD_ADDRESS
                            (
                              ( taken_constant expression_? | valueexp )
                              ( KWD_WITH connection_ )?
                            )? ;
  taken_constant            : symbol_ | STRING ;
  valueexp                  : KWD_VALUE expression_ ;
  connection_               : error_ adio? | input_ adeo? | output_ adei? ;
    adio                    : input_ output_? | output_ input_? ;
      input_                : KWD_INPUT resourcei ;
        resourcei           : resources_ | KWD_NORMAL ;
      output_               : KWD_OUTPUT resourceo ;
        resourceo           : ( KWD_APPEND | KWD_REPLACE)? resources_ | KWD_NORMAL ;
    adeo                    : error_ output_? | output_ error_? ;
      error_                : KWD_ERROR resourceo ;
    adei                    : error_ input_? | input_ error_? ;
resources_                  : ( KWD_STREAM | KWD_STEM ) VAR_SYMBOL ;
  vref                      : SYM_Bracket_Round_O var_symbol_ SYM_Bracket_Round_C ;
    var_symbol_             : VAR_SYMBOL ;
arg_                        : KWD_ARG template_list? ;
call_                       : KWD_CALL ( callon_spec | taken_constant expression_list? ) ;
  callon_spec               :
                            (
                            KWD_ON callable_condition ( KWD_NAME taken_constant )?
                            |
                            KWD_OFF callable_condition
                            ) ;
    callable_condition      : KWD_ERROR | KWD_FAILURE | KWD_HALT | KWD_NOTREADY ;
  expression_list           : expr_ | expr_? ',' expression_list? ;
do_specification            : do_simple | do_repetitive ;
  do_simple                 : KWD_DO ;
  do_repetitive             :
                            (
                            KWD_DO dorep
                            |
                            KWD_DO docond
                            |
                            KWD_DO dorep docond
                            |
                            KWD_DO KWD_FOREVER docond?
                            ) ;
  docond                    : KWD_WHILE whileexpr | KWD_UNTIL untilexpr ;
    untilexpr               : expression_ ;
    whileexpr               : expression_ ;
  dorep                     : assignment_ docount? | repexpr ;
    repexpr                 : expression_ ;
    docount                 : dot dobf? | dob dotf? | dof dotb? ;
      dobf                  : dob dof? | dof dob? ;
      dotf                  : dot dof? | dof dot? ;
      dotb                  : dot dob? | dob dot? ;
      dot                   : KWD_TO toexpr ;
        toexpr              : expression_ ;
      dob                   : KWD_BY byexpr ;
        byexpr              : expression_ ;
      dof                   : KWD_FOR forexpr ;
        forexpr             : expression_ ;
drop_                       : KWD_DROP variable_list ;
  variable_list             : ( vref | var_symbol_ )+ ;
exit_                       : KWD_EXIT expression_? ;
interpret_                  : KWD_INTERPRET expression_ ;
iterate_                    : KWD_ITERATE VAR_SYMBOL? ;
leave_                      : KWD_LEAVE VAR_SYMBOL? ;
nop_                        : KWD_NOP ;
numeric_                    : KWD_NUMERIC ( numeric_digits | numeric_form | numeric_fuzz ) ;
  numeric_digits            : KWD_DIGITS expression_? ;
  numeric_form              : KWD_FORM ( KWD_ENGINEERING | KWD_SCIENTIFIC | valueexp ) ;
  numeric_fuzz              : KWD_FUZZ expression_? ;
options_                    : KWD_OPTIONS expression_ ;
parse_                      : KWD_PARSE KWD_UPPER? parse_type template_list? ;
  parse_type                : parse_key | parse_value | parse_var ;
  parse_key                 : KWD_ARG | KWD_PULL | KWD_SOURCE | KWD_LINEIN | KWD_VERSION ;
  parse_value               : KWD_VALUE expression_? KWD_WITH ;
  parse_var                 : KWD_VAR var_symbol_ ;
procedure_                  : KWD_PROCEDURE ( KWD_EXPOSE variable_list)? ;
pull_                       : KWD_PULL template_list? ;
push_                       : KWD_PUSH expression_? ;
queue_                      : KWD_QUEUE expression_? ;
return_                     : KWD_RETURN expression_? ;
say_                        : KWD_SAY expression_? ;
signal_                     : KWD_SIGNAL ( signal_spec | valueexp | taken_constant ) ;
  signal_spec               :
                            (
                            KWD_ON condition_ ( KWD_NAME taken_constant )?
                            |
                            KWD_OFF condition_
                            ) ;
    condition_              : callable_condition | KWD_NOVALUE | KWD_SYNTAX | KWD_LOSTDIGITS ;
trace_                      : KWD_TRACE ( taken_constant | valueexp )? ;

/* Note: The next section describes templates. */
template_list               : template_ | template_? ',' template_list? ;
  template_                 : ( trigger_ | target_)+ ;
    target_                 : VAR_SYMBOL | '.' ;
    trigger_                : pattern_ | positional_ ;
      pattern_              : STRING | vrefp ;
        vrefp               : '(' VAR_SYMBOL ')' ;
      positional_           : absolute_positional | relative_positional ;
        absolute_positional : NUMBER | '=' position_ ;
          position_         : NUMBER | vrefp ;
      relative_positional   : ( '+' | '-' ) position_ ;

/* Note: The final part specifies the various forms of symbol, and expression. */
symbol_                     : VAR_SYMBOL | CONST_SYMBOL | NUMBER ;
expression_                 : expr_ ;
  expr_                     : expr_alias ;
    expr_alias              : and_expression | expr_alias or_operator and_expression ;
      or_operator           : OP_Or | OP_Xor ;
      and_expression        : comparison_ | and_expression '&' comparison_ ;
comparison_                 : concatenation_ | comparison_ comparison_operator concatenation_ ;
  comparison_operator       : normal_compare | strict_compare ;
    normal_compare          :
                            (
                            CMP_Eq
                            |
                            CMP_NEq
                            |
                            CMP_LM
                            |
                            CMP_ML
                            |
                            CMP_M
                            |
                            CMP_L
                            |
                            CMP_MEq
                            |
                            CMP_LEq
                            |
                            CMP_NM
                            |
                            CMP_NL
                            ) ;
    strict_compare          :
                            (
                            CMP_Strict_Eq
                            |
                            CMP_Strict_NEq
                            |
                            CMP_Strict_M
                            |
                            CMP_Strict_L
                            |
                            CMP_Strict_ME
                            |
                            CMP_Strict_LE
                            |
                            CMP_Strict_NM
                            |
                            CMP_Strict_NL
                            ) ;
concatenation_              : addition_ | concatenation_ ( ' ' | '||' ) addition_ ;
addition_                   : multiplication_ | addition_ additive_operator multiplication_ ;
  additive_operator         : OP_Add | OP_Sub ;
multiplication_             : power_expression | multiplication_ multiplicative_operator power_expression ;
  multiplicative_operator   : OP_Mul | OP_Div | OP_Remainder | OP_Quotinent ;
power_expression            : prefix_expression | power_expression OP_Power prefix_expression ;
  prefix_expression         : ( '+' | '-' | '\\' ) prefix_expression | term_  ;
    term_                   : symbol_ | STRING | function_ | '(' expr_alias ')' ;
      function_             : taken_constant '(' expression_list? ')' ;