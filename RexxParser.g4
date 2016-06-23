parser grammar RexxParser;
options { tokenVocab=RexxLexer; }

file                        :   program_ EOF ;

program_                    :   ncl? instruction_list? ;
  ncl                       :   null_clause+ ;
    null_clause             :   DELIM+ label_list?
                            |   label_list ;
      label_list            :   ( VAR_SYMBOL COLON DELIM* )+ ;
  instruction_list          :   instruction+ ;
    instruction             :   group_
                            |   single_instruction ncl?
                            ;
single_instruction          :   assignment
                            |   keyword_instruction
                            |   command_
                            ;
  assignment                :   VAR_SYMBOL EQ expression ;
  keyword_instruction       :   address_
                            |   arg_
                            |   call_
                            |   drop_
                            |   exit_
                            |   interpret_
                            |   iterate_
                            |   leave_
                            |   nop_
                            |   numeric_
                            |   options_
                            |   parse_
                            |   procedure_
                            |   pull_
                            |   push_
                            |   queue_
                            |   return_
                            |   say_
                            |   signal_
                            |   trace_
                            |   upper_
                            ;
  command_                  :   expression ;
group_                      :   do_
                            |   if_
                            |   select_
                            ;
  do_                       :   do_specification ncl? instruction_list? do_ending ;
    do_ending               :   KWD_END VAR_SYMBOL? ncl? ;
  if_                       :   KWD_IF expression ncl? then_ else_? ;
    then_                   :   KWD_THEN ncl? instruction ;
    else_                   :   KWD_ELSE ncl? instruction ;
  select_                   :   KWD_SELECT ncl? select_body KWD_END ncl? ;
    select_body             :   when_+ otherwise_? ;
      when_                 :   KWD_WHEN expression ncl? then_ ;
      otherwise_            :   KWD_OTHERWISE ncl? instruction_list? ;

/*
Note: The next part concentrates on the instructions.
It leaves unspecified the various forms of symbol, template and expression. */
address_                    :   KWD_ADDRESS
                                (
                                    ( taken_constant expression? | valueexp )
                                    ( KWD_WITH connection_ )?
                                )?
                            ;
  taken_constant            :   symbol
                            |   STRING
                            ;
  valueexp                  :   KWD_VALUE expression ;
  connection_               :   error adio?
                            |   input adeo?
                            |   output adei?
                            ;
    adio                    :   input output?
                            |   output input?
                            ;
      input                 :   KWD_INPUT resourcei ;
        resourcei           :   resources
                            |   KWD_NORMAL
                            ;
      output                :   KWD_OUTPUT resourceo ;
        resourceo           :   KWD_APPEND resources
                            |   KWD_REPLACE resources
                            |   resources
                            |   KWD_NORMAL
                            ;
    adeo                    :   error output?
                            |   output error?
                            ;
      error                 :   KWD_ERROR resourceo ;
    adei                    :   error input?
                            |   input error?
                            ;
resources                   :   ( KWD_STREAM | KWD_STEM ) VAR_SYMBOL ;
arg_                        :   KWD_ARG template_list? ;
call_                       :   KWD_CALL ( callon_spec | taken_constant call_parms? ) ;
  callon_spec               :   KWD_ON callable_condition ( KWD_NAME taken_constant )?
                            |   KWD_OFF callable_condition
                            ;
    callable_condition      :   KWD_ERROR
                            |   KWD_FAILURE
                            |   KWD_HALT
                            |   KWD_NOTREADY
                            ;
  call_parms                :   BR_O expression_list? BR_C
                            |   expression_list
                            ;
//  expression_list           :   ( expr? COMMA )* expr ;
  expression_list           :   COMMA* expr ( COMMA+ expr )* ;
do_specification            :   do_repetitive
                            |   do_simple
                            ;
  do_simple                 :   KWD_DO ;
  do_repetitive             :   KWD_DO dorep
                            |   KWD_DO docond
                            |   KWD_DO dorep docond
                            |   KWD_DO KWD_FOREVER docond?
                            ;
  docond                    :   KWD_WHILE whileexpr
                            |   KWD_UNTIL untilexpr
                            ;
    untilexpr               :   expression ;
    whileexpr               :   expression ;
  dorep                     :   assignment docount?
                            |   repexpr
                            ;
    repexpr                 :   expression ;
    docount                 :   dot dobf?
                            |   dob dotf?
                            |   dof dotb?
                            ;
      dobf                  :   dob dof?
                            |   dof dob?
                            ;
      dotf                  :   dot dof?
                            |   dof dot?
                            ;
      dotb                  :   dot dob?
                            |   dob dot?
                            ;
      dot                   :   KWD_TO toexpr ;
        toexpr              :   expression ;
      dob                   :   KWD_BY byexpr ;
        byexpr              :   expression ;
      dof                   :   KWD_FOR forexpr ;
        forexpr             :   expression ;
drop_                       :   KWD_DROP variable_list ;
  variable_list             :   ( vref | VAR_SYMBOL )+ ;
    vref                    :   BR_O VAR_SYMBOL BR_C ;
exit_                       :   KWD_EXIT expression? ;
interpret_                  :   KWD_INTERPRET expression ;
iterate_                    :   KWD_ITERATE VAR_SYMBOL? ;
leave_                      :   KWD_LEAVE VAR_SYMBOL? ;
nop_                        :   KWD_NOP ;
numeric_                    :   KWD_NUMERIC ( numeric_digits | numeric_form | numeric_fuzz ) ;
  numeric_digits            :   KWD_DIGITS expression? ;
  numeric_form              :   KWD_FORM ( KWD_ENGINEERING | KWD_SCIENTIFIC | valueexp ) ;
  numeric_fuzz              :   KWD_FUZZ expression? ;
options_                    :   KWD_OPTIONS expression ;
parse_                      :   KWD_PARSE KWD_UPPER? parse_type template_list? ;
  parse_type                :   parse_key
                            |   parse_value
                            |   parse_var
                            ;
    parse_key               :   KWD_ARG
                            |   KWD_PULL
                            |   KWD_SOURCE
                            |   KWD_LINEIN
                            |   KWD_VERSION
                            ;
    parse_value             :   KWD_VALUE expression? KWD_WITH ;
    parse_var               :   KWD_VAR VAR_SYMBOL ;
procedure_                  :   KWD_PROCEDURE ( KWD_EXPOSE variable_list )? ;
pull_                       :   KWD_PULL template_list? ;
push_                       :   KWD_PUSH expression? ;
queue_                      :   KWD_QUEUE expression? ;
return_                     :   KWD_RETURN expression? ;
say_                        :   KWD_SAY expression? ;
signal_                     :   KWD_SIGNAL ( signal_spec | valueexp | taken_constant ) ;
  signal_spec               :   KWD_ON condition ( KWD_NAME taken_constant )?
                            |   KWD_OFF condition
                            ;
    condition               :   callable_condition
                            |   KWD_NOVALUE
                            |   KWD_SYNTAX
                            |   KWD_LOSTDIGITS
                            ;
trace_                      :   KWD_TRACE ( taken_constant | valueexp )? ;
upper_                      :   KWD_UPPER VAR_SYMBOL+ ; // if stem -> signal of error (cannot do 'upper j.')

/* Note: The next section describes templates. */
//template_list               :   ( template_? COMMA )* template_ ;
template_list               :   COMMA* template_ ( COMMA+ template_ )* ;
  template_                 :   ( trigger_ | target_ )+? ;
    target_                 :   VAR_SYMBOL
                            |   STOP
                            ;
    trigger_                :   pattern_
                            |   positional_
                            ;
      pattern_              :   STRING
                            |   vref
                            ;
      positional_           :   absolute_positional
                            |   relative_positional
                            ;
        absolute_positional :   NUMBER
                            |   EQ position_
                            ;
          position_         :   NUMBER
                            |   vref
                            ;
      relative_positional   :   (PLUS | MINUS) position_ ;

// Note: The final part specifies the various forms of symbol, and expression.
symbol                      :   VAR_SYMBOL
                            |   CONST_SYMBOL
                            |   NUMBER
                            ;
expression                  :   expr ;
//  expr                      :   ( and_expression or_operator )* and_expression ;
  expr                      :   and_expression ( or_operator and_expression )* ;
      or_operator           :   OR
                            |   XOR
                            ;
//    and_expression        :   ( comparison AND )* comparison ;
      and_expression        :   comparison ( AND comparison )* ;
//comparison                  :   ( concatenation comparison_operator )* concatenation ;
comparison                  :   concatenation ( comparison_operator concatenation )* ;
  comparison_operator       :   normal_compare
                            |   strict_compare
                            ;
    normal_compare          :   EQ
                            |   CMP_NEq
                            |   CMP_LM
                            |   CMP_ML
                            |   CMP_M
                            |   CMP_L
                            |   CMP_MEq
                            |   CMP_LEq
                            |   CMP_NM
                            |   CMP_NL
                            ;
    strict_compare          :   CMPS_Eq
                            |   CMPS_Neq
                            |   CMPS_M
                            |   CMPS_L
                            |   CMPS_MEq
                            |   CMPS_LEq
                            |   CMPS_NM
                            |   CMPS_NL
                            ;
//concatenation               :   ( addition CONCAT? )* addition ;
concatenation               :   addition ( CONCAT? addition )*? ;
//addition                    :   ( multiplication additive_operator )* multiplication ;
addition                    :   multiplication ( additive_operator multiplication )* ;
  additive_operator         :   PLUS
                            |   MINUS
                            ;
//multiplication              :   ( power_expression multiplicative_operator )* power_expression
multiplication              :   power_expression ( multiplicative_operator power_expression )* ;
  multiplicative_operator   :   MUL
                            |   DIV
                            |   QUOTINENT
                            |   REMAINDER
                            ;
//power_expression            :   ( prefix_expression POW )* prefix_expression ;
power_expression            :   prefix_expression ( POW prefix_expression )* ;
  prefix_expression         :   ( PLUS | MINUS | NOT )* term ;
    term                    :   symbol
                            |   STRING
                            |   function_
                            |   BR_O expr  BR_C
                            ;
      function_             :   function_name BR_O expression_list? BR_C ;
        function_name       :   KWD_ADDRESS
                            |   KWD_ARG
                            |   KWD_DIGITS
                            |   KWD_FORM
                            |   KWD_FUZZ
                            |   KWD_TRACE
                            |   KWD_VALUE
                            |   taken_constant
                            ;