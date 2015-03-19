//TODO démultipléxer les règles pour se simplifier la vie du code c
%{
#include <stdlib.h>
#include <stdio.h>
#include "table_symb.h"


FILE * ASM;

void yyerror (char*s);
extern int yylineno;
%}

%union {long type_long; int expo; int num; char* var;}


     
%token tLE tLT tGE tGT tNE tEQUAL
%token <var> tVAR
%token <num> tNUM
%token <expo> tEXPO
%token tOPAR tCPAR tVIR tSEMICOLON 
%token tEQ
%token tPLUS tLESS tMUL tDIV
%token tWHILE tIF tELSE tPRINTF
%token tOBRACKET tCBRACKET tINT tCONST
%token tMAIN

%right tEQ
%left tPLUS tLESS
%left tMUL tDIV


%type <expo> Operation
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
	
Instruction: Operation tSEMICOLON				{clearTemp();
												printTabSymb();}
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

	| tVAR							{
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
	| tVAR tVIR AssignmentConst 				{
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
	
	| tVAR							{
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

Operation: tOPAR Operation tCPAR	{
										int ptemp = addTemp();
										printTabSymb();
										$$ = ptemp;
									}

	| Operation tPLUS Operation				{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"ADD %d %d %d\n",ptemp,$1,$3);
									$$ = ptemp;
								}
								
	| Operation tLESS Operation				{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"LESS %d %d %d\n",ptemp,$1,$3);
									$$ = ptemp;
								}
								
	| Operation tMUL Operation				{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"MUL %d %d %d\n",ptemp,$1,$3);
									$$ = ptemp;
								}
						
	| Operation tDIV Operation				{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"DIV %d %d %d\n",ptemp,$1,$3);
									$$ = ptemp;
								}
								
								
	| tVAR tEQ Operation					{
									fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
									printTabSymb();
									$$ = getAddr($1);
								}

	| tLESS Operation				{
										int ptemp_neg = addTemp();
										int ptemp = addTemp();
										fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
										fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,$2);
										$$ = ptemp;
									}
									
	| tNUM 							{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"AFC %d %d\n",ptemp, $1);
									$$ = ptemp;
								}
	
	| tVAR							{       
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"COP %d %d\n", ptemp, getAddr($1));
									$$ = ptemp; 
								}
	
	| tEXPO 						{       
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"AFC %d %d\n",ptemp, $1);
									$$ = ptemp;
								}
	

	
	;

Statement: While
	| If
	| Printf
	| Declaration
	| tSEMICOLON
	//| Else
	;

While: tWHILE tOPAR Expressions tCPAR Statement
	| tWHILE tOPAR Expressions tCPAR tOBRACKET Instructions tCBRACKET
	;

If: tIF tOPAR Expression tCPAR Statement
	;

/*Else: tElse............	//rajouter le non terminal else pour développer les tELSE
	; */

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

int main(){
    
    ASM = fopen("ASM.txt", "w+"); //on supprime le contenu au préalable avant de réécrire 

    if (ASM == NULL){
       printf("fichier ASM.txt inexistant dans ce répertoire ! ");
    }else{
    	yyparse();
    	fclose(ASM);
    	//réouvrir le fichier pour le copier dans le vrai fichier final en remplaçant tout les saut manquant avec la pile que l'on va créer pour les sauts
    }

}
