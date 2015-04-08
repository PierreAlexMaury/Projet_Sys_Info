%{
#include <stdlib.h>
#include <stdio.h>
#include "inst.tab.h"
%}

%option yylineno


NUMBER [0-9]+

%%

"COP"	{return tCOP;}
"AFC"	{return tAFC;}
"EQU"	{return tEQU;}
"LEQ"	{return tLEQ;}
"INF"	{return tINF;}
"SEQ"	{return tSEQ;}
"SUP"	{return tSUP;}
"ADD"	{return tADD;}
"LESS"  {return tLESS;}
"MUL"   {return tMUL;}
"DIV"	{return tDIV;}
"JMP"	{return tJMP;}
"JMF"	{return tJMF;}
"PRI"	{return tPRI;}
" "		{}
"\n"	{yylineno;}
"\t"	{}

{NUMBER}	{
				yylval.num = atoi(yytext);
				return tNUM;
			}

%%