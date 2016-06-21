parser grammar RexxParser;
options { tokenVocab=RexxLexer; }

file                        :   program_ ;

program_                    :   ncl? instruction_list? ;
  ncl                       :   null_clause+ ;
    null_clause             :   DELIM label_list? ;
//      label_list            :   ( LABEL DELIM )+ ;
      label_list            :   ( DELIM )+ ;
  instruction_list          :   instruction+ ;
    instruction             :   group_
                            |   single_instruction ncl
                            ;
single_instruction          :   assignment
//                            |   keyword_instruction
                            |   command_
                            |   ;
  assignment                :   VAR_SYMBOL OP_Assign expression ;
  command_                  :   expression ;
group_                      :   do_
                            |   if_
                            |   select_
                            ;
  do_                       :   do_specification ncl instruction_list? do_ending ;
    do_ending               :   KWD_END VAR_SYMBOL? ncl ;
  if_                       :   KWD_IF expression ncl? then_ else_? ;
    then_                   :   KWD_THEN ncl instruction ;
    else_                   :   KWD_ELSE ncl instruction ;
  select_                   :   KWD_SELECT ncl select_body KWD_END ncl ;
    select_body             :   when_+ otherwise_? ;
      when_                 :   KWD_WHEN expression ncl? then_ ;
      otherwise_            :   KWD_OTHERWISE ncl instruction_list? ;


/*
Note: The next part concentrates on the instructions.
It leaves unspecified the various forms of symbol, template and expression. */
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



// Note: The final part specifies the various forms of symbol, and expression.
symbol                      :   VAR_SYMBOL
                            |   CONST_SYMBOL
                            |   NUMBER
                            ;
expression                  :   expr ;
  expr                      :   expr_alias ;
    expr_alias              :   and_expression
                            |   expr_alias or_operator and_expression
                            ;
      or_operator           :   OP_Or
                            |   OP_Xor
                            ;
      and_expression        :   comparison
                            |   and_expression OP_And comparison
                            ;
comparison                  :   concatenation
                            |   comparison comparison_operator concatenation
                            ;
  comparison_operator       :   normal_compare
                            |   strict_compare
                            ;
    normal_compare          :   CMP_Eq
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
concatenation               :   addition
                            |   concatenation CONCAT? addition
                            ;
addition                    :   multiplication
                            |   addition additive_operator multiplication
                            ;
  additive_operator         :   Add
                            |   Sub
                            ;
multiplication              :   power_expression
                            |   multiplication multiplicative_operator power_expression
                            ;
  multiplicative_operator   :   OP_Mul
                            |   OP_Div
                            |   OP_Quotinent
                            |   OP_Remainder
                            ;
power_expression            :   prefix_expression
                            |   power_expression OP_Pow prefix_expression
                            ;
  prefix_expression         :   ( Add | Sub | PRE_Not ) prefix_expression
                            |   term
                            ;
    term                    :   symbol
                            |   STRING
//                            |   function
                            |   BR_O expr_alias  BR_C
                            ;
//      function              :   taken_constant BR_O expression_list? BR_C ;