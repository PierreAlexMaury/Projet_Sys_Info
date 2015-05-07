%{
#include <stdlib.h>
#include <stdio.h>
#include "table_symb.h"

FILE * ASM;
FILE * debbug_out;

void yyerror (const char*s);
extern int yylineno;
int compteur = 1;
int num_fonction = 0;
int nb_fonctions = 0;
%}

%union {int expo; int num; char* var;}

%error-verbose
     
%token tLE tLT tGE tGT tNE tEQUAL
%token <var> tVAR
%token <num> tNUM
%token <expo> tEXPO
%token tOPAR tCPAR tVIR tSEMICOLON 
%token tEQ
%token tPLUS tLESS tMUL tDIV
%token tWHILE tIF tELSE tPRINTF
%token tOBRACKET tCBRACKET tINT tCONST tRETURN
%token tMAIN

%right tEQ
%left tPLUS tLESS
%left tMUL tDIV

%type <expo> Operation 
%type <num> While Nsautw
%type <var> AssignmentInt AssignmentConst
%start Start
	 
%%
	Start: Fonctions Raz Main
	;

	Fonctions: CreateTable Fonction Fonctions 
	|
	;

	Raz:
		{
			num_fonction = 0;
			setLine_main(compteur);
			printf("Remise à zero et sauvegarde ligne Main\n");

		}
	;

	CreateTable: 
		{
			createTable();
			num_fonction++;
			nb_fonctions++;
			printf("Table %d crée\n", num_fonction);
		}
	;

	Fonction: tINT NommerFonction tOPAR tINT tVAR tCPAR Block 
		{
			printf("Execution code pour fonction avec table %d\n",num_fonction);
		}
		| tINT NommerFonction tOPAR tCONST tINT tVAR tCPAR Block
		| tINT NommerFonction tOPAR tCPAR Block
	;

	NommerFonction: tVAR
		{
			nommerTable(num_fonction,$1);
			printf("on vient de nommer la table %d %s\n",num_fonction,$1);
			setLineASM(num_fonction,compteur);
			printf("on vient de setter la ligne %d de la fonction dans la table %d\n",compteur,num_fonction);
		}
	;

	Main: tMAIN Block
		{
			int i;
			for (i=0; i <= nb_fonctions; i++)
				printTabSymb(i);

			printTableCond();
		}
	;

	Block: tOBRACKET Declarations Instructions tCBRACKET	
	;

	Declarations: Declaration Declarations			
		|
	;

	Declaration: tCONST tINT tVAR tSEMICOLON	
		{	
			if (!findSymb($3,num_fonction)) {
				addSymb($3,1,num_fonction);
														
			}else {
				printf("ECHEC: %s existe deja\n",$3);
			}
		}
										
		| tINT tVAR tSEMICOLON		
		{
			if (!findSymb($2,num_fonction)) {
				addSymb($2,0,num_fonction);
										
			}else {
				printf("ECHEC: %s existe deja\n",$2);
			}
		}
	
		| tCONST tINT AssignmentConst tSEMICOLON					
		| tINT AssignmentInt tSEMICOLON
	;
	
	AssignmentInt: tVAR tVIR AssignmentInt	
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tVAR tVIR AssignmentInt 
		{	
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
			if (!findSymb($3,num_fonction)) {
				printf("ECHEC: %s n'existe pas\n",$3);													
			}else{
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), getAddr($3,num_fonction));
				compteur++;
				
			} 
        }


		| tVAR tEQ tLESS tVAR tVIR AssignmentInt 
		{	
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
			if (!findSymb($4,num_fonction)) {
				printf("ECHEC: %s n'existe pas\n",$4);
			}else{
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
				compteur++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,getAddr($4,num_fonction));
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction) , ptemp);
				compteur ++;
				clearTemp(num_fonction);
			} 
		}
						

		| tVAR tEQ tVAR				
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
			if (!findSymb($3,num_fonction)) {
				printf("ECHEC: %s n'existe pas\n",$3);
			}else{
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), getAddr($3,num_fonction));
				compteur ++;
				
			}
		}

		| tVAR tEQ tLESS tVAR		
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
			if (!findSymb($4,num_fonction)) {
				printf("ECHEC: %s n'existe pas\n",$4);
			}else{
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,getAddr($4,num_fonction));
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}
		}

		| tVAR tEQ tNUM tVIR AssignmentInt 
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n",ptemp, $3);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tLESS tNUM tVIR AssignmentInt 
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				int ptemp_2 = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"AFC %d %d\n", ptemp_2,$4);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,ptemp_2);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}									

		| tVAR tEQ tNUM				
		{ 
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n",ptemp, $3);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tLESS tNUM		
		{ 
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				int ptemp_2 = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"AFC %d %d\n", ptemp_2,$4);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,ptemp_2);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}


		| tVAR tEQ tEXPO tVIR AssignmentInt 
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n",ptemp, $3);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tLESS tEXPO tVIR AssignmentInt	
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				int ptemp_2 = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"AFC %d %d\n", ptemp_2,$4);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,ptemp_2);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tEXPO				
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n",ptemp, $3);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tLESS tEXPO			
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				int ptemp_2 = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"AFC %d %d\n", ptemp_2,$4);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,ptemp_2);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}
	
		| tVAR							
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,0,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}
	;
	
	AssignmentConst: tVAR tVIR AssignmentConst	
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tVAR tVIR AssignmentConst 
		{	
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
			if (!findSymb($3,num_fonction)) {
				printf("ECHEC: %s n'existe pas\n",$3);													
			}else{
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), getAddr($3,num_fonction));
				compteur ++;	
		    } 
        }


		| tVAR tEQ tLESS tVAR tVIR AssignmentConst 
		{	
			if (!findSymb($1,num_fonction)) {
					addSymb($1,1,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
			if (!findSymb($4,num_fonction)) {
				printf("ECHEC: %s n'existe pas\n",$4);
			}else{
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,getAddr($4,num_fonction));
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			} 
    	}
						

		| tVAR tEQ tVAR				
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
			if (!findSymb($3,num_fonction)) {
				printf("ECHEC: %s n'existe pas\n",$3);
			}else{
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), getAddr($3,num_fonction));
				compteur ++;
			}
		}

		| tVAR tEQ tLESS tVAR		
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
			if (!findSymb($4,num_fonction)) {
				printf("ECHEC: %s n'existe pas\n",$4);
			}else{
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,getAddr($4,num_fonction));
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}
		}

		| tVAR tEQ tNUM tVIR AssignmentConst 
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n",ptemp, $3);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tLESS tNUM tVIR AssignmentConst 
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				int ptemp_2 = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"AFC %d %d\n", ptemp_2,$4);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,ptemp_2);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}									

		| tVAR tEQ tNUM				
		{ 
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n",ptemp, $3);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tLESS tNUM		
		{ 
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				int ptemp_2 = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"AFC %d %d\n", ptemp_2,$4);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,ptemp_2);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}


		| tVAR tEQ tEXPO tVIR AssignmentConst 
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n",ptemp, $3);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), $3);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tLESS tEXPO tVIR AssignmentConst	
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				int ptemp_2 = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"AFC %d %d\n", ptemp_2,$4);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,ptemp_2);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tEXPO				
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
				int ptemp = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n",ptemp, $3);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}

		| tVAR tEQ tLESS tEXPO			
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
				int ptemp_neg = addTemp(num_fonction);
				int ptemp = addTemp(num_fonction);
				int ptemp_2 = addTemp(num_fonction);
				fprintf(ASM,"AFC %d %d\n", ptemp_neg,-1);
				compteur ++;
				fprintf(ASM,"AFC %d %d\n", ptemp_2,$4);
				compteur ++;
				fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,ptemp_2);
				compteur ++;
				fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), ptemp);
				compteur ++;
				clearTemp(num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}
	
		| tVAR							
		{
			if (!findSymb($1,num_fonction)) {
				addSymb($1,1,num_fonction);
			}else {
				printf("ECHEC: %s existe deja\n",$1);
			}
		}
	;

	Instructions: Instruction Instructions
		|
	;
	
	Instruction: Operation tSEMICOLON				
		{
			clearTemp(num_fonction);
		}
		| Statement
	;

	Operation: tOPAR Operation tCPAR	
		{
			int ptemp = addTemp(num_fonction);
			$$ = ptemp;
		}

		| Operation tPLUS Operation		
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"ADD %d %d %d\n",ptemp,$1,$3);
			compteur ++;
			$$ = ptemp;
		}
								
		| Operation tLESS Operation		
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"LESS %d %d %d\n",ptemp,$1,$3);
			compteur ++;
			$$ = ptemp;
		}
								
		| Operation tMUL Operation	
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"MUL %d %d %d\n",ptemp,$1,$3);
			compteur ++;
			$$ = ptemp;
		}
						
		| Operation tDIV Operation	
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"DIV %d %d %d\n",ptemp,$1,$3);
			compteur ++;
			$$ = ptemp;
		}
								
								
		| tVAR tEQ Operation		
		{
			fprintf(ASM,"COP %d %d\n", getAddr($1,num_fonction), $3);
			compteur ++;
			$$ = getAddr($1,num_fonction);
		}

		| tLESS Operation				
		{
			int ptemp_neg = addTemp(num_fonction);
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
			compteur ++;
			fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,$2);
			compteur ++;
			$$ = ptemp;
		}
									
		| tNUM 						
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"AFC %d %d\n",ptemp, $1);
			compteur ++;
			$$ = ptemp;
		}
	
		| tVAR						
		{       
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"COP %d %d\n", ptemp, getAddr($1,num_fonction));
			compteur ++;
			$$ = ptemp; 
		}
	
		| tEXPO 					
		{       
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"AFC %d %d\n",ptemp, $1);
			compteur ++;
			$$ = ptemp;
		}
	;

	Statement: While
		| BIfElse
		| Printf
		| Declaration
		| AppelFonction
		| Return
		| tSEMICOLON
	;

	Return : tRETURN Operation
		{
			printf("Will return %d\n",$2);
		}
	;

	AppelFonction: tVAR tOPAR tCPAR
		{
			int line = getLineASM($1);
			if(line == -1) {
				printf("Echec: fonction %s n'existe pas\n",$1);
			}
			else {
				/* TODO : pusher */
				fprintf(ASM,"JMP %d\n",line);
				compteur++;
			}
		}
		| tVAR tOPAR tVAR tCPAR
		{
			int line = getLineASM($1);
			if(line == -1) {
				printf("Echec: fonction %s n'existe pas\n",$1);
			}
			else {
				/* TODO : pusher */
				fprintf(ASM,"JMP %d\n",line);
				compteur++;
			}
		}
		| tVAR tOPAR tNUM tCPAR
		{
			int line = getLineASM($1);
			if(line == -1) {
				printf("Echec: fonction %s n'existe pas\n",$1);
			}
			else {
				/* TODO : pusher */
				fprintf(ASM,"JMP %d\n",line);
				compteur++;
			}
		}
		| tVAR tOPAR tEXPO tCPAR
		{
			int line = getLineASM($1);
			if(line == -1) {
				printf("Echec: fonction %s n'existe pas\n",$1);
			}
			else {
				/* TODO : pusher */
				fprintf(ASM,"JMP %d\n",line);
				compteur++;
			}
		}
	;

	While: tWHILE Nsautw tOPAR Condition tCPAR Instruction																
		{
			fprintf(ASM,"JMP %d\n",$2);
			compteur++;
			pushCond(-1, compteur);
		
		}
		| tWHILE Nsautw tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET											
		{

			fprintf(ASM,"JMP %d\n",$2);
			compteur++;
			pushCond(-1, compteur);
		}
 	;

	BIfElse: tIF tOPAR Condition tCPAR Instruction tELSE Nsaut Instruction											
		{
			pushCond(-1,compteur);
		}

		| tIF tOPAR Condition tCPAR Instruction						
		{
			pushCond(-1,compteur);
		}
		| tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET tELSE Nsaut Instruction 
		{
			pushCond(-1,compteur);
		}

		| tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET		
		{
			pushCond(-1,compteur);
		}
	
		| tIF tOPAR Condition tCPAR Instruction tELSE Nsaut tOBRACKET Instructions tCBRACKET	
		{
			pushCond(-1,compteur);
		}
	
		| tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET tELSE  Nsaut tOBRACKET Instructions tCBRACKET	
		{
			pushCond(-1,compteur);
		}

	;	

	Nsautw:	
		{
			$$ = compteur;
		}
	;

	Nsaut:	
		{
			fprintf(ASM,"JMP %c\n",'?');
			compteur++;
			pushCond(-1,compteur);
			pushCond(compteur-1,-1);
		}
	;
	
	Condition: Operation tEQUAL Operation		
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"EQU %d %d %d\n",ptemp,$1,$3);
			compteur++;
			fprintf(ASM,"JMF %d %c\n", ptemp, '?');
			pushCond(compteur,-1);
			compteur++;

		}
		| Operation tNE Operation				
		{	
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"LESS %d %d %d\n",ptemp,$1,$3);
			compteur++;
			fprintf(ASM,"JMF %d %c\n", ptemp, '?');
			pushCond(compteur,-1);
			compteur++;	
		}
		| Operation tLE Operation				
		{	
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"LEQ %d %d %d\n",ptemp,$1,$3);
			compteur++;
			fprintf(ASM,"JMF %d %c\n", ptemp, '?');
			pushCond(compteur,-1);
			compteur++;	
		}
		| Operation tLT Operation				
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"INF %d %d %d\n",ptemp,$1,$3);
			compteur++;
			fprintf(ASM,"JMF %d %c\n", ptemp, '?');
			pushCond(compteur,-1);
			compteur++;
		}
		| Operation tGE Operation				
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"SEQ %d %d %d\n",ptemp,$1,$3);
			compteur++;
			fprintf(ASM,"JMF %d %c\n", ptemp, '?');
			pushCond(compteur,-1);
			compteur++;	
		}
		| Operation tGT Operation				
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"SUP %d %d %d\n",ptemp,$1,$3);
			compteur++;
			fprintf(ASM,"JMF %d %c\n", ptemp, '?');
			pushCond(compteur,-1);
			compteur++;	
		}
		| Operation								
		{
			int ptemp = addTemp(num_fonction);
			fprintf(ASM,"JMF %d %c\n", ptemp, '?');
			pushCond(compteur,-1);
			printTableCond();
			compteur++;
		}
	;	

	Printf: tPRINTF tOPAR tVAR tCPAR tSEMICOLON	
		{
			fprintf(ASM,"PRI %d\n",getAddr($3,num_fonction));
			compteur++;
		}
	;

%%
void yyerror(const char*s){
    printf("line %d : %s\n", yylineno, s);
}

int main(){
    
    ASM = fopen("ASM_temp.txt", "w+"); //on supprime le contenu au préalable avant de réécrire 
	debbug_out = fopen("debbug_out.txt","w+");


    if (ASM == NULL){
       printf("fichier ASM.txt inexistant dans ce répertoire ! \n");
	}else if(debbug_out == NULL) {
		printf("fichier debbug_out.txt inexistant !\n");
    }else{
    	fprintf(debbug_out,"\n*** Nous sommes dans le fichier de debbug ***\n\n");
    	createTable();
    	nommerTable(0,"main");
    	fprintf(ASM,"JMP ?\n");
    	compteur++;
    	yyparse();
    	fclose(ASM);
		fclose(debbug_out);
    	toASM("ASM_temp.txt");
    }

}
