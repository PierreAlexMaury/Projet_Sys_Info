%{
#include <stdlib.h>
#include <stdio.h>
void yyerror (char*s);
extern int yylineno;
%}

%union {long expo; int num; char* var;}


%token tMAIN tOBRACKET tCBRACKET tWHILE tIF tELSE tCONST tINT tPLUS tLESS tMUL tDIV tEQ tOPAR tCPAR tVIR tSEMICOLON tPRINTF
%token tLE tLT tGE tGT tNE tEQUAL
%token <var> tVAR
%token <num> tNUM
%token <expo> tEXPO
%start Main
	 
%%
Main: tMAIN Block
	;

Block: tOBRACKET Declaration tCBRACKET
	;

Declaration: tCONST tINT Assignment tSEMICOLON 
	| tINT Assignment tSEMICOLON
	| Assignment tSEMICOLON
	| StatementList
	;

Assignment: tVAR tEQ Assignment
	| tVAR tVIR Assignment
	| tNUM tVIR Assignment 
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
	| tLESS tOPAR Assignment tCPAR
	| tLESS tNUM
	| tLESS tVAR
	| tLESS tEXPO
	| tNUM
	| tVAR
	| tEXPO
	;

StatementList: StatementList Statement
	|
	;

Statement: While
	| If
	| Printf
	| Declaration
	| tSEMICOLON
	;

While: tWHILE tOPAR Expression tCPAR Statement
	| tWHILE tOPAR Expression tCPAR tOBRACKET StatementList tCBRACKET
	;

If: tIF tOPAR Expression tCPAR Statement
	| tIF tOPAR Expression tCPAR tOBRACKET StatementList tCBRACKET
	| tIF tOPAR Expression tCPAR tOBRACKET StatementList tCBRACKET tELSE tOBRACKET StatementList tCBRACKET
	;

Printf: tPRINTF tOPAR Assignment tCPAR tSEMICOLON
	;

Expression: Expression tEQUAL Expression
	| Expression tNE Expression
	| Expression tLE Expression
	| Expression tLT Expression
	| Expression tGE Expression
	| Expression tGT Expression
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
