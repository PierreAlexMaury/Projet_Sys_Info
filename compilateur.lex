%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option yylineno

/*Déclarations d'expr reg*/

NUMBER [0-9]+
EXPONENTIAL {NUMBER}e{NUMBER}
INTEGER {NUMBER}|{EXONENTIAL}
VAR [A-Za-z][A-Z_a-z0-9]*


%%

"main()"	{return tMAIN;}
"{"		{return tOBRACKET;}
"}"		{return tCBRACKET;}
"const"		{return tCONST;}
"int"		{return tINT;}
"if"    	{return tIF;}
"while" 	{return tWHILE;}
"else"  	{return tELSE;}
"=="    	{return tEQUAL;}
"<="    	{return tLE;}
">="    	{return tGE;}
"!="    	{return tNE;}
"<"     	{return tLT;}
">"     	{return tGT;}
"+"		{return tPLUS;}
"-"		{return tLESS;}
"*"		{return tMUL;}
"/"		{return tDIV;}
"="		{return tEQ;}
"("		{return tOPAR;}
")" 		{return tCPAR;}
" "		{}
"\t"		{}
","		{return tVIR;}
"\n"		{yylineno;}
";"		{return tSEMICOLON;}
"printf"	{return tPRINTF;}
{NUMBER}	{yylval.num = atoi(yytext);
		return tNUM;}
{EXPONENTIAL}   {yylval.expo = (int)atof(yytext);
		return tEXPO;}

{VAR}		{yylval.var= strdup(yytext);
		return tVAR;}	

\/\/.* ;
\/\*(.*\n)*.*\*\/ ;	

%%

