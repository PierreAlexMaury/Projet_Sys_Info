/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     tMAIN = 258,
     tOBRACKET = 259,
     tCBRACKET = 260,
     tWHILE = 261,
     tIF = 262,
     tELSE = 263,
     tCONST = 264,
     tINT = 265,
     tPLUS = 266,
     tLESS = 267,
     tMUL = 268,
     tDIV = 269,
     tEQ = 270,
     tOPAR = 271,
     tCPAR = 272,
     tVIR = 273,
     tSEMICOLON = 274,
     tPRINTF = 275,
     tLE = 276,
     tLT = 277,
     tGE = 278,
     tGT = 279,
     tNE = 280,
     tEQUAL = 281,
     tVAR = 282,
     tNUM = 283,
     tEXPO = 284
   };
#endif
/* Tokens.  */
#define tMAIN 258
#define tOBRACKET 259
#define tCBRACKET 260
#define tWHILE 261
#define tIF 262
#define tELSE 263
#define tCONST 264
#define tINT 265
#define tPLUS 266
#define tLESS 267
#define tMUL 268
#define tDIV 269
#define tEQ 270
#define tOPAR 271
#define tCPAR 272
#define tVIR 273
#define tSEMICOLON 274
#define tPRINTF 275
#define tLE 276
#define tLT 277
#define tGE 278
#define tGT 279
#define tNE 280
#define tEQUAL 281
#define tVAR 282
#define tNUM 283
#define tEXPO 284




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 8 "compilateur.y"
{long expo; int num; char* var;}
/* Line 1529 of yacc.c.  */
#line 109 "y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

