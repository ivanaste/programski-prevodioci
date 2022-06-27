%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"
  #include "codegen.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

  extern int yylineno;
  int out_lin = 0;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
  int tmpcall_idx = -1;
  int lab_num = -1;
  
  int arguments_number = 0;
  int template_arguments[128];
  
  //moj deo
  int param_idx = 0;
  //moj deo
  
  FILE *output;
%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token <i> _AROP
%token <i> _RELOP
%token _TEMPLATE
%token _TYPENAME
%token _T
%token _COMMA	
%token _OSMICA
%token _POINTER

%type <i> num_exp exp literal
%type <i> function_call argument argument_template arguments_template template_function_call

%nonassoc ONLY_IF
%nonassoc _ELSE
%right OPERATOR


%%

program
  : function_list
      {  
        if(lookup_symbol("main", FUN) == NO_INDEX)
          err("undefined reference to 'main'");
      }
  ;

function_list
  : function
  | function_list function
  ;


function
	: template_function 
	  | _TYPE _ID
	      {
		fun_idx = lookup_symbol($2, FUN|TMP);
		if(fun_idx == NO_INDEX)
		  fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
		else 
		  err("redefinition of function '%s'", $2);

		code("\n%s:", $2);
		code("\n\t\tPUSH\t%%14");
		code("\n\t\tMOV \t%%15,%%14");
	      }
	    _LPAREN parameter _RPAREN body
	      {
		clear_symbols(fun_idx + 1);
		var_num = 0;
		
		code("\n@%s_exit:", $2);
		code("\n\t\tMOV \t%%14,%%15");
		code("\n\t\tPOP \t%%14");
		code("\n\t\tRET");
		
		//fun_idx = -1;
	      }
  ;
  
  
template_function
	: _TEMPLATE _RELOP _TYPENAME _T _RELOP
	{
		if ($2 != 0) err("allowed operator for template is <");
		if ($5 != 1) err("allowed operator for template is >");
	} _T _ID 
	{
		fun_idx = lookup_symbol($8, FUN|TMP);
		if (fun_idx == NO_INDEX) 
		  fun_idx = insert_symbol($8, TMP, 3, NO_ATR, NO_ATR);
		else 
		  err("redefinition of template '%s'", $8);
		  
		code("\n%s:", $8);
		code("\n\t\tPUSH\t%%14");
		code("\n\t\tMOV \t%%15,%%14");
		
		param_idx = 0;

	}
	_LPAREN template_parameters _RPAREN body 
	{
		param_idx = 0;
		//fun_idx = -1;
		
		code("\n@%s_exit:", $8);
		code("\n\t\tMOV \t%%14,%%15");
		code("\n\t\tPOP \t%%14");
		code("\n\t\tRET");
	}
	;
	
template_parameters
	: template_parameter
	| template_parameters _COMMA template_parameter
	;
	
template_parameter
	: _T _ID
	{	
		param_idx = param_idx + 1;
		//tip parametra je T, index parametra, kom templejtu pripada
		insert_symbol($2, PAR, 3, param_idx, fun_idx);
		//na kraju atr1 templejta je broj parametara (index poslednjeg param)
		set_atr1(fun_idx, param_idx);
		
	}
	;
	

parameter
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | _TYPE _ID
      {
        insert_symbol($2, PAR, $1, 1, NO_ATR);
        set_atr1(fun_idx, 1);
        set_atr2(fun_idx, $1);
      }
  ;


body
  : _LBRACKET variable_list
      {
        if(var_num)
          code("\n\t\tSUBS\t%%15,$%d,%%15", 4*var_num);
        code("\n@%s_body:", get_name(fun_idx));
      }
    statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

variable
  : _TYPE _ID _SEMICOLON
      {
      	int varIndex = lookup_symbol($2, VAR|PAR|POINT);
      	int atr2 = get_atr2(varIndex);
      	
      	//provera da li postoji promenljiva u okviru funkcije
        if(varIndex == NO_INDEX || atr2 != fun_idx)
           insert_symbol($2, VAR, $1, ++var_num, fun_idx);
        else 
           err("redefinition of '%s'", $2);
      }
  | _TYPE _POINTER _ID _SEMICOLON
  	{
  	//FUN IDX TI MOZDA TREBA
  	
  	 int varIndex = lookup_symbol($3, VAR|PAR|POINT);
      	 int atr2 = get_atr2(varIndex);
         if(varIndex == NO_INDEX || atr2 != fun_idx)
           insert_symbol($3, POINT, $1, ++var_num, fun_idx);
         else 
           err("redefinition of '%s'", $3);
      }
  ;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | return_statement
  ;

compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;
    

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, VAR|PAR);
        if(idx == NO_INDEX)
          err("invalid lvalue '%s' in assignment", $1);
        else
          if((get_type(idx) != 3) && (get_type($3) != 3) && (get_type(idx) != get_type($3)))
            err("incompatible types in assignment");
            
        gen_mov($3, idx);
        
      }
  | _ID _ASSIGN _OSMICA num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, POINT);
        if(idx == NO_INDEX)
          err("invalid pointer '%s' in assignment", $1);
        else
          if(get_type(idx) != get_type($4))
            err("incompatible types in assignment");
       
        
      }
  ;

num_exp
  : exp

  | num_exp _AROP exp
      {
        if(get_type($1) != 3 && get_type($3) != 3 && (get_type($1) != get_type($3)))
          err("invalid operands: arithmetic operation");
        int t1 = get_type($1);    
        
        code("\n\t\t%s\t", ar_instructions[$2 + (t1 - 1) * AROP_NUMBER]);
        gen_sym_name($1);
        code(",");
        gen_sym_name($3);
        code(",");
        free_if_reg($3);
        free_if_reg($1);
        $$ = take_reg();
        gen_sym_name($$);
        set_type($$, t1);
        print_symtab();
      }
  ;

exp
  : literal
  
  | function_call
      {
        $$ = take_reg();
        gen_mov(FUN_REG, $$);
      }
   | template_function_call
   {
   	 $$ = take_reg();
        gen_mov(FUN_REG, $$);
   }

  | _ID
      {
        $$ = lookup_symbol($1, VAR|PAR);
        if($$ == NO_INDEX)
          err("'%s' undeclared", $1);
      }
 
  
  | _LPAREN num_exp _RPAREN
      { $$ = $2; }
  ;

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;
  

function_call
  : _ID _LPAREN
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("'%s' is not a function", $1);
      }
     argument _RPAREN
      {
        if(get_atr1(fcall_idx) != $4)
          err("wrong number of arguments");
        code("\n\t\t\tCALL\t%s", get_name(fcall_idx));
        if($4 > 0)
          code("\n\t\t\tADDS\t%%15,$%d,%%15", $4 * 4);
        set_type(FUN_REG, get_type(fcall_idx));
        $$ = FUN_REG;
      }
  ;
  
template_function_call
	: _ID _RELOP 
	{
		tmpcall_idx = lookup_symbol($1, TMP);
		if(tmpcall_idx == NO_INDEX)
		  err("'%s' is not a template", $1);
	} _TYPE 
	{	//postavljam atr2 na izabrani tip
		set_atr2(tmpcall_idx, $4);
		//type se postavlja zbog poredjenja return-a
		set_type(tmpcall_idx, $4);
		arguments_number = 0;
	}
	_RELOP _LPAREN arguments_template _RPAREN 
	{
		if(get_atr1(tmpcall_idx) != $8)
		  err("wrong number of arguments");
		
		  
		for (int i=arguments_number - 1; i >= 0; i--) {
			free_if_reg(template_arguments[i]);
		        code("\n\t\t\tPUSH\t");
		      	gen_sym_name(template_arguments[i]);
			
		}
		  
		code("\n\t\t\tCALL\t%s", get_name(tmpcall_idx));
		if($8 > 0)
		  code("\n\t\t\tADDS\t%%15,$%d,%%15", $8 * 4);
		
		arguments_number = 0;
		
		set_type(FUN_REG, get_type(tmpcall_idx));
		$$ = FUN_REG;
		
	}
      	;
      
      
arguments_template
	: argument_template
	{ 
		$$ = $1; 
	}
	| arguments_template 
	_COMMA argument_template 
	{
		$$ = $3;	
	}
	;
	

argument_template
	: num_exp
	 { 
	      if(get_atr2(tmpcall_idx) != get_type($1))
		err("incompatible type for template argument");
		
              
              template_arguments[arguments_number]=$1;
              
              arguments_number = arguments_number + 1;
              $$ = arguments_number;
	 }
  	;

  
 
argument
  : /* empty */
    { $$ = 0; }

  | num_exp
    { 
    	
      if(get_atr2(fcall_idx) != get_type($1))
        err("incompatible type for argument");
      free_if_reg($1);
      code("\n\t\t\tPUSH\t");
      gen_sym_name($1);
      $$ = 1;
    }
  ;



return_statement
  : _RETURN num_exp _SEMICOLON
      {
    
      	//ako je return T moze biti bilo koji tip
        if(get_type(fun_idx) != 3 && get_type(fun_idx) != get_type($2))
          err("incompatible types in return");
        gen_mov($2, FUN_REG);
        code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));      
      
      }
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();
  output = fopen("output.asm", "w+");

  synerr = yyparse();

  clear_symtab();
  fclose(output);
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count) {
    remove("output.asm");
    printf("\n%d error(s).\n", error_count);
  }

  if(synerr)
    return -1;  //syntax error
  else if(error_count)
    return error_count & 127; //semantic errors
  else if(warning_count)
    return (warning_count & 127) + 127; //warnings
  else
    return 0; //OK
}

