grammar Rexx;

file                        :   program_ EOF;

/* The first part introduces the overall structure of a program */
program_                    :
                            (
                            ncl?
                            |
                            instruction_list?
                            |
                            KWD_END Msg10_1
                            ) ;
  ncl                       : null_clause+ | Msg21_1 ;
    null_clause             : ';' label_list? ;
      label_list            : ( LABEL ';' )+ ;
  instruction_list          : instruction_+ ;
    instruction_            : group_ | single_instruction ncl ;

single_instruction          : assignment_ | keyword_instruction | command_ ;
  assignment_               :
                            (
                            VAR_SYMBOL '=' expression_
                            |
                            NUMBER '=' Msg31_1
                            |
                            CONST_SYMBOL '=' ( Msg31_2 | Msg31_3 )
                            ) ;
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
                            |
                            KWD_THEN Msg8_1
                            |
                            KWD_ELSE Msg8_2
                            |
                            KWD_WHEN Msg9_1
                            |
                            KWD_OTHERWISE Msg9_2
                            ) ;
  command_                  : expression_ ;
group_                      : do_ | if_ | select_ ;
  do_                       : do_specification ( ncl | Msg21_1 | Msg27_1 ) instruction_list? do_ending ;
    do_ending               : KWD_END VAR_SYMBOL? ncl | EOS Msg14_1 | Msg35_1 ;
  if_                       : KWD_IF expression_ ncl? ( then_ | Msg18_1 ) else_? ;
    then_                   : KWD_THEN ncl ( instruction_ | EOS Msg14_3 | KWD_END Msg10_5 ) ;
    else_                   : KWD_ELSE ncl ( instruction_ | EOS Msg14_4 | KWD_END Msg10_6 ) ;
  select_                    : KWD_SELECT ncl select_body
                              (
                              KWD_END ( VAR_SYMBOL Msg10_4 )? ncl
                              |
                              EOS Msg14_2
                              |
                              Msg7_2
                              )
                            ;
    select_body             : ( when_ | Msg7_1 ) ( when_+ )? otherwise_? ;
  when_                     : KWD_WHEN expression_ ncl? ( then_ | Msg18_2 ) ;
      otherwise_            : KWD_OTHERWISE ncl instruction_list? ;
/*
Note: The next part concentrates on the instructions.
It leaves unspecified the various forms of symbol, template
and expression.
*/
address_                    : KWD_ADDRESS
                            (
                              (
                              taken_constant expression_?
                              |
                              Msg19_1
                              |
                              valueexp
                              )
                              ( KWD_WITH connection_ )?
                            )? ;
  taken_constant            : symbol_ | STRING ;
  valueexp                  : KWD_VALUE expression_ ;
  connection_               : error_ adio? | input_ adeo? | output_ adei? | Msg25_5 ;
    adio                    : input_ output_? | output_ input_? ;
      input_                : KWD_INPUT ( resourcei | Msg25_6 ) ;
        resourcei           : resources_ | KWD_NORMAL ;
      output_               : KWD_OUTPUT ( resourceo | Msg25_7 ) ;
        resourceo           :
                            (
                            KWD_APPEND ( resources_ | Msg25_8 )
                            |
                            KWD_REPLACE ( resources_ | Msg25_9 )
                            |
                            resources_
                            |
                            KWD_NORMAL
                            ) ;
    adeo                    : error_ output_? | output_ error_? ;
      error_                : KWD_ERROR ( resourceo | Msg25_14 ) ;
    adei                    : error_ input_? | input_ error_? ;
resources_                  :
                            (
                            KWD_STREAM ( VAR_SYMBOL | Msg53_1 )
                            |
                            KWD_STEM ( VAR_SYMBOL | Msg53_2 )
                            ) ;
  vref                      : '(' var_symbol_ ( ')' | Msg46_1 ) ;
    var_symbol_             : VAR_SYMBOL | Msg20_1 ;
arg_                        : KWD_ARG template_list? ;
call_                       : KWD_CALL
                              (
                              callon_spec
                              |
                              ( taken_constant | Msg19_2 ) expression_list?
                              )
                            ;
  callon_spec               :
                            (
                            KWD_ON ( callable_condition | Msg25_1 ) ( KWD_NAME ( taken_constant | Msg19_3 ) )?
                            |
                            KWD_OFF ( callable_condition | Msg25_2 )
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
                            KWD_DO KWD_FOREVER ( docond | Msg25_16 )?
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
iterate_                    : KWD_ITERATE ( VAR_SYMBOL | Msg20_2 )? ;
leave_                      : KWD_LEAVE ( VAR_SYMBOL | Msg20_2 )? ;
nop_                        : KWD_NOP ;
numeric_                    : KWD_NUMERIC ( numeric_digits | numeric_form | numeric_fuzz | Msg25_15 ) ;
  numeric_digits            : KWD_DIGITS expression_? ;
  numeric_form              : KWD_FORM ( KWD_ENGINEERING | KWD_SCIENTIFIC | valueexp | Msg25_11 ) ;
  numeric_fuzz              : KWD_FUZZ expression_? ;
options_                    : KWD_OPTIONS expression_ ;
parse_                      :
                            (
                            KWD_PARSE ( parse_type | Msg25_12 ) template_list?
                            |
                            KWD_PARSE KWD_UPPER ( parse_type | Msg25_13 ) template_list?
                            ) ;
  parse_type                : parse_key | parse_value | parse_var ;
  parse_key                 : KWD_ARG | KWD_PULL | KWD_SOURCE | KWD_LINEIN | KWD_VERSION ;
  parse_value               : KWD_VALUE expression_? ( KWD_WITH | Msg38_3 ) ;
  parse_var                 : KWD_VAR var_symbol_ ;
procedure_                  : KWD_PROCEDURE ( KWD_EXPOSE variable_list | Msg25_17 )? ;
pull_                       : KWD_PULL template_list? ;
push_                       : KWD_PUSH expression_? ;
queue_                      : KWD_QUEUE expression_? ;
return_                     : KWD_RETURN expression_? ;
say_                        : KWD_SAY expression_? ;
signal_                      : KWD_SIGNAL ( signal_spec | valueexp | taken_constant | Msg19_4 ) ;
  signal_spec               :
                            (
                            KWD_ON ( condition_ | Msg25_3 ) ( KWD_NAME ( taken_constant | Msg19_3 ) )?
                            |
                            KWD_OFF ( condition_ | Msg25_4 )
                            ) ;
    condition_              : callable_condition | KWD_NOVALUE | KWD_SYNTAX | KWD_LOSTDIGITS ;
trace_                      : KWD_TRACE ( ( taken_constant | Msg19_6 ) | valueexp )? ;

/* Note: The next section describes templates. */
template_list               : template_ | template_? ',' template_list? ;
  template_                 : ( trigger_ | target_ | Msg38_1 )+ ;
    target_                 : VAR_SYMBOL | '.' ;
    trigger_                : pattern_ | positional_ ;
      pattern_              : STRING | vrefp ;
        vrefp               : '(' ( VAR_SYMBOL | Msg19_7 ) ( ')' | Msg46_1 ) ;
      positional_           : absolute_positional | relative_positional ;
        absolute_positional : NUMBER | '=' position_ ;
          position_         : NUMBER | vrefp | Msg38_2 ;
      relative_positional   : ( '+' | '-' ) position_ ;

/* Note: The final part specifies the various forms of symbol, and expression. */
symbol_                     : VAR_SYMBOL | CONST_SYMBOL | NUMBER ;
expression_                 : expr_
                              (
                              ( ',' Msg37_1 )
                              |
                              ( ')' Msg37_2 )
                              )?
                            ;
  expr_                     : expr_alias ;
    expr_alias              : and_expression | expr_alias or_operator and_expression ;
      or_operator           : '|' | '&&' ;
      and_expression        : comparison_ | and_expression '&' comparison_ ;
comparison_                  : concatenation_ | comparison_ comparison_operator concatenation_ ;
  comparison_operator       : normal_compare | strict_compare ;
    normal_compare          : '=' | '\\=' | '<>' | '><' | '>' | '<' | '>=' | '<=' | '\\>' | '\\<' ;
    strict_compare          : '==' | '\\==' | '>>' | '<<' | '>>=' | '<<=' | '\\>>' | '\\<<' ;
concatenation_              : addition_ | concatenation_ ( ' ' | '||' ) addition_ ;
addition_                   : multiplication_ | addition_ additive_operator multiplication_ ;
  additive_operator         : '+' | '-' ;
multiplication_             : power_expression | multiplication_ multiplicative_operator power_expression ;
  multiplicative_operator   : '*' | '/' | '//' | '%' ;
power_expression            : prefix_expression | power_expression '**' prefix_expression ;
  prefix_expression         : ( '+' | '-' | '\\' ) prefix_expression | term_ | Msg35_1 ;
    term_                   : symbol_ | STRING | function_ | '(' expr_alias ( ',' Msg37_1 | ')' | Msg36 ) ;
      function_             : taken_constant '(' expression_list? ( ')' | Msg36 ) ;