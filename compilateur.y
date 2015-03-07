//TODO démultipléxer les règles pour se simplifier la vie du code c
%{
#include <stdlib.h>
#include <stdio.h>
#include "table_symb.h"

#define __cpluplus
#define	__STDC__

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

Declaration: tCONST tINT tVAR tSEMICOLON			{	if (!findSymb($3)) {
										addSymb($3,1);
										printTabSymb();
									}else {
										printf("ECHEC: %s existe deja\n",$3);
									}
								}
										
	| tINT tVAR tSEMICOLON					{
									if (!findSymb($2)) {
										addSymb($2,0);
										printTabSymb();
									}else {
										printf("ECHEC: %s existe deja\n",$2);
									}
								}
	
	| tCONST tINT AssignmentConst tSEMICOLON					
	| tINT AssignmentInt tSEMICOLON
	;
	
Instructions: Instruction Instructions
	|
	;
	
Instruction: Operation tSEMICOLON
	| Statement
	;

AssignmentInt: tNUM tVIR AssignmentInt
	| tVAR tVIR AssignmentInt				{
												if (!findSymb($1)) {
													addSymb($1,0);
													printTabSymb();
												}else {
													printf("ECHEC: %s existe deja\n",$1);
												}
											}

	| tVAR tEQ AssignmentInt				{
												if (!findSymb($1)) {
													addSymb($1,0);
													printTabSymb();
												}else {
													printf("ECHEC: %s existe deja\n",$1);
												}
											}

	| tVAR									{
												if (!findSymb($1)) {
													addSymb($1,0);
													printTabSymb();
												}else {
													printf("ECHEC: %s existe deja\n",$1);
												}
											}
	| tNUM 
	| tEXPO 
	;
	
AssignmentConst: tNUM tVIR AssignmentConst 
	| tVAR tVIR AssignmentConst 			{
												if (!findSymb($1)) {
													addSymb($1,1);
													printTabSymb();
												}else {
													printf("ECHEC: %s existe deja\n",$1);
												}
											}

	| tVAR tEQ AssignmentConst				{
												if (!findSymb($1)) {
													addSymb($1,1);
													printTabSymb();
												}else {
													printf("ECHEC: %s existe deja\n",$1);
												}
											}
	
	| tVAR									{
												if (!findSymb($1)) {
													addSymb($1,1);
													printTabSymb();
												}else {
													printf("ECHEC: %s existe deja\n",$1);
												}
											}				
	| tEXPO  
	| tNUM
	;

Assignment: tNUM tVIR Assignment
    | tVAR tVIR Assignment
    | tVAR tEQ Assignment
    | tNUM
    | tVAR
    | tEXPO
    ;

Operation: tNUM tVIR Operation
	| tVAR tVIR Operation
	| tVAR tEQ Operation
	| tVAR tPLUS Operation
	| tVAR tLESS Operation
	| tVAR tDIV Operation
	| tVAR tMUL Operation
	| tNUM tPLUS Operation
	| tNUM tLESS Operation
	| tNUM tDIV Operation
	| tNUM tMUL Operation
	| tEXPO tPLUS Operation
    	| tEXPO tLESS Operation
    	| tEXPO tDIV Operation
    	| tEXPO tMUL Operation
	| tOPAR Operation tCPAR
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

int main(int argc, char* argv[]){
	printf("toto");
	printf("%d",argc);
    yyparse(argv[0]);
    return 0;
}
