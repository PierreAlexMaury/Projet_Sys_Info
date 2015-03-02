%{
#include <stdlib.h>
#include <stdio.h>
void yyerror (char*s);
extern int yylineno;
%}

%union {long expo; int num; char* var;}


     
%token tLE tLT tGE tGT tNE tEQUAL
%token <var> tVAR
%token <num> tNUM
%token <expo> tEXPO
%token tOPAR tCPAR tVIR tSEMICOLON 
%token tPLUS tLESS tEQ
%token tMUL tDIV 
%token tWHILE tIF tELSE tPRINTF
%token tOBRACKET tCBRACKET tINT tCONST
%token tMAIN
%start Main
	 
%%
Main: tMAIN Block
	;

Block: tOBRACKET Declarations Instructions tCBRACKET
	;

Declarations: Declaration Declarations
	|
	;

Declaration: tCONST tINT Assignment tSEMICOLON 
	| tINT Assignment tSEMICOLON
	;
	
Instructions: Instruction Instructions
	|
	;
	
Instruction: Assignment tSEMICOLON
	| Statement
	;

Assignment: tNUM tVIR Assignment 
	| tVAR tVIR Assignment
	| tVAR tEQ Assignment
	| tVAR tPLUS Assignment
	| tVAR tLESS Assignment
	| tVAR tDIV Assignment
	| tVAR tMUL Assignment
	| tNUM tPLUS Assignment
	| tNUM tLESS Assignment
	| tNUM tDIV Assignment
	| tNUM tMUL Assignment
	| tEXPO tPLUS Assignment
    	| tEXPO tLESS Assignment
    	| tEXPO tDIV Assignment
    	| tEXPO tMUL Assignment
	| tOPAR Assignment tCPAR
	| tNUM 
	| tVAR 
	| tEXPO 
	;

Statement: While
	| If
	| Printf
	| Declaration
	| tSEMICOLON
	;

While: tWHILE tOPAR Expressions tCPAR Statement
	| tWHILE tOPAR Expressions tCPAR tOBRACKET Instructions tCBRACKET
	;

If: tIF tOPAR Expression tCPAR Statement
	| tIF tOPAR Expressions tCPAR tOBRACKET Instructions tCBRACKET
	| tIF tOPAR Expressions tCPAR tOBRACKET Instructions tCBRACKET tELSE tOBRACKET Instructions tCBRACKET
	;

Printf: tPRINTF tOPAR tVAR tCPAR tSEMICOLON
	;

Expressions: Expression Expressions
	| 
	;
	
Expression: Assignment tEQUAL Assignment
	| Assignment tNE Assignment
	| Assignment tLE Assignment
	| Assignment tLT Assignment
	| Assignment tGE Assignment
	| Assignment tGT Assignment
	| Assignment
	;

%%
void yyerror(char*s){
    printf("%d : %s\n", yylineno, s);
}

int main(void){
    yyparse();
    return 0;
}
