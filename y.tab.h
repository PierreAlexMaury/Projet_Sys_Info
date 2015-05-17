/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tLE = 258,
    tLT = 259,
    tGE = 260,
    tGT = 261,
    tNE = 262,
    tEQUAL = 263,
    tVAR = 264,
    tNUM = 265,
    tEXPO = 266,
    tOPAR = 267,
    tCPAR = 268,
    tVIR = 269,
    tSEMICOLON = 270,
    tEQ = 271,
    tPLUS = 272,
    tLESS = 273,
    tMUL = 274,
    tDIV = 275,
    tWHILE = 276,
    tIF = 277,
    tELSE = 278,
    tPRINTF = 279,
    tOBRACKET = 280,
    tCBRACKET = 281,
    tINT = 282,
    tCONST = 283,
    tRETURN = 284,
    tMAIN = 285
  };
#endif
/* Tokens.  */
#define tLE 258
#define tLT 259
#define tGE 260
#define tGT 261
#define tNE 262
#define tEQUAL 263
#define tVAR 264
#define tNUM 265
#define tEXPO 266
#define tOPAR 267
#define tCPAR 268
#define tVIR 269
#define tSEMICOLON 270
#define tEQ 271
#define tPLUS 272
#define tLESS 273
#define tMUL 274
#define tDIV 275
#define tWHILE 276
#define tIF 277
#define tELSE 278
#define tPRINTF 279
#define tOBRACKET 280
#define tCBRACKET 281
#define tINT 282
#define tCONST 283
#define tRETURN 284
#define tMAIN 285

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 16 "compilateur.y" /* yacc.c:1909  */
int expo; int num; char* var;

#line 117 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
