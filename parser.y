%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.c"
	#include "codeGen.h"
	#include "semantic.h"
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
	int int_val;
	list_t* id;
}

%token<int_val> INT IF ELSE DO WHILE FOR CONTINUE BREAK PRINT INC DEC
%token<int_val> ADDOP SUBOP MULOP DIVOP EQUOP NEQUOP LT GT GTE LTE
%token<int_val> LPAREN RPAREN LBRACE RBRACE SEMI ASSIGN
%token <id> ID
%token <int_val> ICONST

%left ADDOP SUBOP MULOP DIVOP
%left LT GT GTE LTE
%left EQUOP NEQUOP
%right ASSIGN

%start program

%%
program: {gen_code(START, -1);} code {gen_code(HALT, -1);} ;

code: statements statement;

declaration:  INT ID SEMI
			  {
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
			  }
			  | INT ID ASSIGN exp SEMI
			  {
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
				  list_t* id = search($2->st_name);
				  gen_code(STORE, id->address);
			  }
			  ;

statements: statements statement |  ;

statement: assigment SEMI 
		  | declaration
		  | PRINT ID SEMI
		  {
			  int address = id_check($2->st_name);
			  
			  if(address!=-1)
				  gen_code(WRITE_INT, address);
			  else
			  	exit(1);
		  }
		  | if_statement
		  | while_statement
		  | do_while_statement
		  | for_statement
		  | inc_dec_statement
		  ;

assigment: ID ASSIGN exp 
		   {
			   int address = id_check($1->st_name);
			  
			  if(address!=-1)
				  gen_code(STORE, address);
			  else 
			  	exit(1);
		   }
		   ;		  


inc_dec_statement:  ID INC SEMI
					{
						int address = id_check($1->st_name);

						if(address !=-1){
							gen_code(LD_VAR,address);
							gen_code(LD_INT,1);
							gen_code(ADD,-1);
							gen_code(STORE,address);
							
						}

					}
					| ID DEC SEMI
					{
						int address = id_check($1->st_name);

						if(address !=-1){
							gen_code(LD_VAR,address);
							gen_code(LD_INT,-1);
							gen_code(ADD,-1);
							gen_code(STORE,address);
							
						}

					}
					;
	  

if_statement: IF LPAREN exp RPAREN {gen_code(JMP_FALSE, 1);} LBRACE statements RBRACE {gen_code(GOTO, 2);} opt_else ;

opt_else: /*epsilon*/ {gen_code(LABEL,2);gen_code(LABEL,1);} |ELSE {gen_code(LABEL,1);} LBRACE statements RBRACE {gen_code(LABEL,2);};

for_statement: 
FOR LPAREN statement {gen_code(LABEL,8);} exp {gen_code(JMP_FALSE,6);gen_code(GOTO,9);} SEMI {gen_code(LABEL,7);} statements {gen_code(GOTO,8);} RPAREN LBRACE {gen_code(LABEL,9);} statements {gen_code(GOTO,7);} RBRACE {gen_code(LABEL,6);}
;

while_statement: 
{gen_code(LABEL,3);} WHILE LPAREN exp {gen_code(JMP_FALSE,4);} RPAREN LBRACE statements {gen_code(GOTO,3);} RBRACE {gen_code(LABEL,4);} ;

do_while_statement:
DO LBRACE {gen_code(LABEL,5);} statements RBRACE WHILE LPAREN exp {gen_code(JMP_TRUE,5);} RPAREN SEMI;


exp:  ID  
	  {
		  int address = id_check($1->st_name);
			  
			  if(address!=-1)
				  gen_code(LD_VAR, address);
			  else 
			  	exit(1);
	  }
	| ICONST { gen_code(LD_INT, $1); }
	| exp ADDOP exp { gen_code(ADD, -1); } 		  
	| exp SUBOP exp { gen_code(SUB, -1);}		  
	| exp MULOP exp { gen_code(MUL,-1);}		  
	| exp DIVOP exp { gen_code(DIV,-1);}		  
	| exp EQUOP exp { gen_code(EQ, -1);}
	| exp NEQUOP exp {gen_code(NEQ, -1);}		  
	| exp GT exp {gen_code(GTN, -1);}	  	  
	| exp GTE exp {gen_code(GTNE, -1);}	  	  
	| exp LT exp {gen_code(LTN, -1);}  	  
	| exp LTE exp {gen_code(LTNE, -1);}  	    
	| LPAREN exp RPAREN
	;

%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[])
{
	int flag;
	flag = yyparse();
	
	printf("Parsing finished!\n");	

	printf("\n\n================STACK MACHINE INSTRUCTIONS================\n");
	print_code();

	printf("\n\n================MIPS assembly================\n");
	printf("Assembly code written to assembly.s file\n");
	print_assembly();

	return flag;
}
