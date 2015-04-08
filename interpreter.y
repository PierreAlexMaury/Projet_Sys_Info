%{
#include <stdlib.h>
#include <stdio.h>
#include "table_interpreter.h"

void yyerror (char*s);
extern int yylineno;
%}

%union {int num;}

%error-verbose

%token tCOP tAFC tEQU tLEQ tINF tSEQ tSUP tADD tLESS tMUL tDIV tJMP tJMF tPRI
%token <num> tNUM

%start Start

%%

Start: Instructions
	;

Instructions: Instruction Instructions
	|
	;

Instruction:	tCOP tNUM tNUM	{
							addInst(5,$2,$3,0);
						}
	 |	tAFC tNUM tNUM	{
							addInst(6,$2,$3,0);
							}
	 |	tEQU tNUM tNUM tNUM	{
							addInst(11,$2,$3,$4);
							}
	 |	tLEQ tNUM tNUM tNUM	{
							addInst(13,$2,$3,$4);
							}
	 |	tINF tNUM tNUM tNUM	{
							addInst(9,$2,$3,$4);
							}
	 |	tSEQ tNUM tNUM tNUM	{
							addInst(14,$2,$3,$4);
							}
	 |	tSUP tNUM tNUM tNUM	{
							addInst(10,$2,$3,$4);
							}
	 |	tADD tNUM tNUM tNUM	{
							addInst(1,$2,$3,$4);
							}
	 |	tLESS tNUM tNUM tNUM {
							addInst(3,$2,$3,$4);
							}
	 |	tMUL tNUM tNUM tNUM	{
							addInst(2,$2,$3,$4);
							}
	 |	tDIV tNUM tNUM tNUM	{
							addInst(4,$2,$3,$4);
							}
	 |	tJMP tNUM			{
							addInst(7,$2,0,0);
							}
	 |	tJMF tNUM tNUM 		{
							addInst(8,$2,$3,0);
							}
	 |	tPRI tNUM			{
							addInst(12,$2,0,0);
							}
	 ;

	 %%

void yyerror(char*s){
    printf("%d : %s\n", yylineno, s);
}

int main(){
    yyparse();
    printTabInst();
    execute();
    printTabVar(5);
}