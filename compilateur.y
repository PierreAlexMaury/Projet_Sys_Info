%{
#include <stdlib.h>
#include <stdio.h>
#include "table_symb.h"


FILE * ASM;
FILE * debbug_out;

void yyerror (char*s);
extern int yylineno;
int compteur = 1;
%}

%union {int expo; int num; char* var;}


     
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
%type <num> While Nsautw
%type <var> AssignmentInt AssignmentConst
%start Main
	 
%%
Main: tMAIN Block
	;

Block: tOBRACKET Declarations Instructions tCBRACKET	
	;

Declarations: Declaration Declarations			
	|
	;

Declaration: tCONST tINT tVAR tSEMICOLON	{	
												if (!findSymb($3)) {
													addSymb($3,1);
													printTabSymb();
												}else {
													printf("ECHEC: %s existe deja\n",$3);
												}
											}
										
	| tINT tVAR tSEMICOLON		{
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
	
	AssignmentInt: tVAR tVIR AssignmentInt	{
											if (!findSymb($1)) {
												addSymb($1,0);
												printTabSymb();
											}else {
												printf("ECHEC: %s existe deja\n",$1);
											}
										}

	| tVAR tEQ tVAR tVIR AssignmentInt {	if (!findSymb($1)) {
												addSymb($1,0);
												printTabSymb();
											}else {
												printf("ECHEC: %s existe deja\n",$1);
											}
											if (!findSymb($3)) {
												printf("ECHEC: %s n'existe pas\n",$3);													
											}else{
												fprintf(ASM,"COP %d %d\n", getAddr($1), getAddr($3));
												compteur++;
												printTabSymb();
											} 
								        }


	| tVAR tEQ tLESS tVAR tVIR AssignmentInt {	if (!findSymb($1)) {
														addSymb($1,0);
														printTabSymb();
													}else {
														printf("ECHEC: %s existe deja\n",$1);
													}
													if (!findSymb($4)) {
														printf("ECHEC: %s n'existe pas\n",$4);
													}else{
														int ptemp_neg = addTemp();
														int ptemp = addTemp();
														fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
														compteur++;
														fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,getAddr($4));
														compteur ++;
														fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
														compteur ++;
														printTabSymb();
														clearTemp();
													} 
								        	}
						

	| tVAR tEQ tVAR				{
									if (!findSymb($1)) {
										addSymb($1,0);
										printTabSymb();
									}else {
										printf("ECHEC: %s existe deja\n",$1);
									}
									if (!findSymb($3)) {
										printf("ECHEC: %s n'existe pas\n",$3);
									}else{
										fprintf(ASM,"COP %d %d\n", getAddr($1), getAddr($3));
										compteur ++;
										printTabSymb();
									}

								}

	| tVAR tEQ tLESS tVAR		{
									if (!findSymb($1)) {
										addSymb($1,0);
										printTabSymb();
									}else {
										printf("ECHEC: %s existe deja\n",$1);
									}
									if (!findSymb($4)) {
										printf("ECHEC: %s n'existe pas\n",$4);
									}else{
										int ptemp_neg = addTemp();
										int ptemp = addTemp();
										fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
										compteur ++;
										fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,getAddr($4));
										compteur ++;
										fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
										compteur ++;
										printTabSymb();
										clearTemp();
									}

								}

	| tVAR tEQ tNUM tVIR AssignmentInt {
											if (!findSymb($1)) {
												addSymb($1,0);
												printTabSymb();
												fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
												compteur ++;
												printTabSymb();
											}else {
												printf("ECHEC: %s existe deja\n",$1);
											}


										}

	| tVAR tEQ tLESS tNUM tVIR AssignmentInt {
												if (!findSymb($1)) {
													addSymb($1,0);
													printTabSymb();
													int ptemp_neg = addTemp();
													int ptemp = addTemp();
													fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
													compteur ++;
													fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,$4);
													compteur ++;
													fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
													compteur ++;
													printTabSymb();
													clearTemp();
												}else {
													printf("ECHEC: %s existe deja\n",$1);
												}

											}									

	| tVAR tEQ tNUM				{ 
									if (!findSymb($1)) {
										addSymb($1,0);
										printTabSymb();
										fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
										compteur ++;
										printTabSymb();
									}else {
										printf("ECHEC: %s existe deja\n",$1);
									}

								}

	| tVAR tEQ tLESS tNUM		{ 
									if (!findSymb($1)) {
										addSymb($1,0);
										printTabSymb();
										int ptemp_neg = addTemp();
										int ptemp = addTemp();
										fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
										compteur ++;
										fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,$4);
										compteur ++;
										fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
										compteur ++;
										printTabSymb();
										clearTemp();
									}else {
										printf("ECHEC: %s existe deja\n",$1);
									}

								}


	| tVAR tEQ tEXPO tVIR AssignmentInt {
											if (!findSymb($1)) {
												addSymb($1,0);
												printTabSymb();
												fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
												compteur ++;
												printTabSymb();
											}else {
												printf("ECHEC: %s existe deja\n",$1);
											}

										}

	| tVAR tEQ tLESS tEXPO tVIR AssignmentInt	{
													if (!findSymb($1)) {
														addSymb($1,0);
														printTabSymb();
														int ptemp_neg = addTemp();
														int ptemp = addTemp();
														fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
														compteur ++;
														fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,$4);
														compteur ++;
														fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
														compteur ++;
														printTabSymb();
														clearTemp();
													}else {
														printf("ECHEC: %s existe deja\n",$1);
													}

												}

	| tVAR tEQ tEXPO				{
										if (!findSymb($1)) {
											addSymb($1,0);
											printTabSymb();
											fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
											compteur ++;
											printTabSymb();
										}else {
											printf("ECHEC: %s existe deja\n",$1);
										}

									}

	| tVAR tEQ tLESS tEXPO			{
										if (!findSymb($1)) {
											addSymb($1,0);
											printTabSymb();
											int ptemp_neg = addTemp();
											int ptemp = addTemp();
											fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
											compteur ++;
											fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,$4);
											compteur ++;
											fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
											compteur ++;
											printTabSymb();
											clearTemp();
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

	;
	
AssignmentConst: tVAR tVIR AssignmentConst	{
											if (!findSymb($1)) {
												addSymb($1,1);
												printTabSymb();
											}else {
												printf("ECHEC: %s existe deja\n",$1);
											}
										}

	| tVAR tEQ tVAR tVIR AssignmentConst {	if (!findSymb($1)) {
												addSymb($1,1);
												printTabSymb();
											}else {
												printf("ECHEC: %s existe deja\n",$1);
											}
											if (!findSymb($3)) {
												printf("ECHEC: %s n'existe pas\n",$3);													
											}else{
												fprintf(ASM,"COP %d %d\n", getAddr($1), getAddr($3));
												compteur ++;
												printTabSymb();
										    } 
								        }


	| tVAR tEQ tLESS tVAR tVIR AssignmentConst {	if (!findSymb($1)) {
														addSymb($1,1);
														printTabSymb();
													}else {
														printf("ECHEC: %s existe deja\n",$1);
													}
													if (!findSymb($4)) {
														printf("ECHEC: %s n'existe pas\n",$4);
													}else{
														int ptemp_neg = addTemp();
														int ptemp = addTemp();
														fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
														compteur ++;
														fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,getAddr($4));
														compteur ++;
														fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
														compteur ++;
														printTabSymb();
														clearTemp();
													} 
								        	}
						

	| tVAR tEQ tVAR				{
									if (!findSymb($1)) {
										addSymb($1,1);
										printTabSymb();
									}else {
										printf("ECHEC: %s existe deja\n",$1);
									}
									if (!findSymb($3)) {
										printf("ECHEC: %s n'existe pas\n",$3);
									}else{
										fprintf(ASM,"COP %d %d\n", getAddr($1), getAddr($3));
										compteur ++;
										printTabSymb();
									}

								}

	| tVAR tEQ tLESS tVAR		{
									if (!findSymb($1)) {
										addSymb($1,1);
										printTabSymb();
									}else {
										printf("ECHEC: %s existe deja\n",$1);
									}
									if (!findSymb($4)) {
										printf("ECHEC: %s n'existe pas\n",$4);
									}else{
										int ptemp_neg = addTemp();
										int ptemp = addTemp();
										fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
										compteur ++;
										fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,getAddr($4));
										compteur ++;
										fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
										compteur ++;
										printTabSymb();
										clearTemp();
									}

								}

	| tVAR tEQ tNUM tVIR AssignmentConst {
											if (!findSymb($1)) {
												addSymb($1,1);
												printTabSymb();
												fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
												compteur ++;
												printTabSymb();
											}else {
												printf("ECHEC: %s existe deja\n",$1);
											}


										}

	| tVAR tEQ tLESS tNUM tVIR AssignmentConst {
												if (!findSymb($1)) {
													addSymb($1,1);
													printTabSymb();
													int ptemp_neg = addTemp();
													int ptemp = addTemp();
													fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
													compteur ++;
													fprintf(ASM,"COP %d %d\n", ptemp,$4);
													compteur ++;
													fprintf(ASM,"MUL %d %d %d\n",getAddr($1),ptemp_neg,ptemp);
													compteur ++;
													printTabSymb();
													clearTemp();
												}else {
													printf("ECHEC: %s existe deja\n",$1);
												}

											}									

	| tVAR tEQ tNUM				{ 
									if (!findSymb($1)) {
										addSymb($1,1);
										printTabSymb();
										fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
										compteur ++;
										printTabSymb();
									}else {
										printf("ECHEC: %s existe deja\n",$1);
									}

								}

	| tVAR tEQ tLESS tNUM		{ 
									if (!findSymb($1)) {
										addSymb($1,1);
										printTabSymb();
										int ptemp_neg = addTemp();
										int ptemp = addTemp();
										fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
										compteur ++;
										fprintf(ASM,"COP %d %d\n", ptemp,$4);
										compteur ++;
										fprintf(ASM,"MUL %d %d %d\n",getAddr($1),ptemp_neg,ptemp);
										compteur ++;
										printTabSymb();
										clearTemp();
									}else {
										printf("ECHEC: %s existe deja\n",$1);
									}

								}


	| tVAR tEQ tEXPO tVIR AssignmentConst {
											if (!findSymb($1)) {
												addSymb($1,1);
												printTabSymb();
												fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
												compteur ++;
												printTabSymb();
											}else {
												printf("ECHEC: %s existe deja\n",$1);
											}

										}

	| tVAR tEQ tLESS tEXPO tVIR AssignmentConst	{
													if (!findSymb($1)) {
														addSymb($1,1);
														printTabSymb();
														int ptemp_neg = addTemp();
														int ptemp = addTemp();
														fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
														compteur ++;
														fprintf(ASM,"COP %d %d\n", ptemp,$4);
														compteur ++;
														fprintf(ASM,"MUL %d %d %d\n",getAddr($1),ptemp_neg,ptemp);
														compteur ++;
														printTabSymb();
														clearTemp();
													}else {
														printf("ECHEC: %s existe deja\n",$1);
													}
												}

	| tVAR tEQ tEXPO				{
										if (!findSymb($1)) {
											addSymb($1,1);
											printTabSymb();
											fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
											compteur ++;
											printTabSymb();
										}else {
											printf("ECHEC: %s existe deja\n",$1);
										}

									}

	| tVAR tEQ tLESS tEXPO			{
										if (!findSymb($1)) {
											addSymb($1,1);
											printTabSymb();
											int ptemp_neg = addTemp();
											int ptemp = addTemp();
											fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
											compteur ++;
											fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,$4);
											compteur ++;
											fprintf(ASM,"COP %d %d\n", getAddr($1), ptemp);
											compteur ++;
											printTabSymb();
											clearTemp();
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

	;

Instructions: Instruction Instructions
	|
	;
	
Instruction: Operation tSEMICOLON				{
													clearTemp();
													printTabSymb();
												}
	| Statement
	;

Operation: tOPAR Operation tCPAR	{
										int ptemp = addTemp();
										printTabSymb();
										$$ = ptemp;
									}

	| Operation tPLUS Operation		{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"ADD %d %d %d\n",ptemp,$1,$3);
									compteur ++;
									$$ = ptemp;
								}
								
	| Operation tLESS Operation				{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"LESS %d %d %d\n",ptemp,$1,$3);
									compteur ++;
									$$ = ptemp;
								}
								
	| Operation tMUL Operation	{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"MUL %d %d %d\n",ptemp,$1,$3);
									compteur ++;
									$$ = ptemp;
								}
						
	| Operation tDIV Operation	{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"DIV %d %d %d\n",ptemp,$1,$3);
									compteur ++;
									$$ = ptemp;
								}
								
								
	| tVAR tEQ Operation		{
									fprintf(ASM,"COP %d %d\n", getAddr($1), $3);
									compteur ++;
									printTabSymb();
									$$ = getAddr($1);
								}

	| tLESS Operation				{
										int ptemp_neg = addTemp();
										int ptemp = addTemp();
										fprintf(ASM,"COP %d %d\n", ptemp_neg,-1);
										compteur ++;
										fprintf(ASM,"MUL %d %d %d\n",ptemp,ptemp_neg,$2);
										compteur ++;
										$$ = ptemp;
									}
									
	| tNUM 						{
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"AFC %d %d\n",ptemp, $1);
									compteur ++;
									$$ = ptemp;
								}
	
	| tVAR						{       
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"COP %d %d\n", ptemp, getAddr($1));
									compteur ++;
									$$ = ptemp; 
								}
	
	| tEXPO 					{       
									int ptemp = addTemp();
									printTabSymb();
									fprintf(ASM,"AFC %d %d\n",ptemp, $1);
									compteur ++;
									$$ = ptemp;
								}
	;

Statement: While
	| BIfElse
	| Printf
	| Declaration
	| tSEMICOLON
	;

While: tWHILE Nsautw tOPAR Condition tCPAR Instruction																{
																														fprintf(debbug_out,"tWHILE Sautw tOPAR Condition tCPAR Instructions\n");
																														fprintf(ASM,"JMP %d\n",$2);
																														compteur++;
																														pushCond(-1, compteur);
																														printTableCond();
		
																													}
	| tWHILE Nsautw tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET											{
																														fprintf(debbug_out,"tWHILE Sautw tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET");
																														fprintf(ASM,"JMP %d\n",$2);
																														compteur++;
																														pushCond(-1, compteur);
																														printTableCond();
																													}
 	;

BIfElse: tIF tOPAR Condition tCPAR Instruction tELSE Nsaut Instruction											{
																														fprintf(debbug_out ,"tIF tOPAR Condition tCPAR Instruction tELSE Instruction\n");
																														pushCond(-1,compteur);
																														printTableCond();
																													}

	| tIF tOPAR Condition tCPAR Instruction																		{
																														fprintf(debbug_out ,"tIF tOPAR Condition tCPAR Instruction\n");
																														pushCond(-1,compteur);
																														printTableCond();
																													}
	| tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET tELSE Nsaut Instruction 						{
																														fprintf(debbug_out ,"tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET tELSE Instruction\n");
																														pushCond(-1,compteur);
																														printTableCond();
																													}

	| tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET													{
																														fprintf(debbug_out ,"tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET\n");
																														pushCond(-1,compteur);
																														printTableCond();
																													}
	
	| tIF tOPAR Condition tCPAR Instruction tELSE Nsaut tOBRACKET Instructions tCBRACKET						{
																														fprintf(debbug_out ,"tIF tOPAR Condition tCPAR Instruction tELSE tOBRACKET Instructions tCBRACKET\n");
																														pushCond(-1,compteur);
																														printTableCond();
																													}
	
	| tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET tELSE  Nsaut tOBRACKET Instructions tCBRACKET	{
																														fprintf(debbug_out ,"tIF tOPAR Condition tCPAR tOBRACKET Instructions tCBRACKET tELSE tOBRACKET Instructions tCBRACKET\n");
																														pushCond(-1,compteur);
																														printTableCond();
																													}

	;

Nsautw:	{
			$$ = compteur;
		}
	;

Nsaut:	{
			fprintf(ASM,"JMP %c\n",'?');
			compteur++;
			pushCond(-1,compteur);
			printTableCond();
			pushCond(compteur-1,-1);
			printTableCond();
		}
	;
	
Condition: Operation tEQUAL Operation		{
												int ptemp = addTemp();
												printTabSymb();
												fprintf(ASM,"EQU %d %d %d\n",ptemp,$1,$3);
												compteur++;
												fprintf(ASM,"JMF %d %c\n", ptemp, '?');
												pushCond(compteur,-1);
												printTableCond();
												compteur++;

											}
	| Operation tNE Operation				{	
												int ptemp = addTemp();
												printTabSymb();
												fprintf(ASM,"LESS %d %d %d\n",ptemp,$1,$3);
												compteur++;
												fprintf(ASM,"JMF %d %c\n", ptemp, '?');
												pushCond(compteur,-1);
												printTableCond();
												compteur++;	
											}
	| Operation tLE Operation				{	
												int ptemp = addTemp();
												printTabSymb();
												fprintf(ASM,"LEQ %d %d %d\n",ptemp,$1,$3);
												compteur++;
												fprintf(ASM,"JMF %d %c\n", ptemp, '?');
												pushCond(compteur,-1);
												printTableCond();
												compteur++;	
											}
	| Operation tLT Operation				{
												int ptemp = addTemp();
												printTabSymb();
												fprintf(ASM,"INF %d %d %d_n",ptemp,$1,$3);
												compteur++;
												fprintf(ASM,"JMF %d %c\n", ptemp, '?');
												pushCond(compteur,-1);
												printTableCond();
												compteur++;
											}
	| Operation tGE Operation				{
												int ptemp = addTemp();
												printTabSymb();
												fprintf(ASM,"SEQ %d %d %d\n",ptemp,$1,$3);
												compteur++;
												fprintf(ASM,"JMF %d %c\n", ptemp, '?');
												pushCond(compteur,-1);
												printTableCond();
												compteur++;	
											}
	| Operation tGT Operation				{
												int ptemp = addTemp();
												printTabSymb();
												fprintf(ASM,"SUP %d %d %d\n",ptemp,$1,$3);
												compteur++;
												fprintf(ASM,"JMF %d %c\n", ptemp, '?');
												pushCond(compteur,-1);
												printTableCond();
												compteur++;	
											}
	| Operation								{
												int ptemp = addTemp();
												fprintf(ASM,"JMF %d %c\n", ptemp, '?');
												pushCond(compteur,-1);
												printTableCond();
												compteur++;
											}
	;

Printf: tPRINTF tOPAR tVAR tCPAR tSEMICOLON
	;

%%
void yyerror(char*s){
    printf("%d : %s\n", yylineno, s);
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
    	yyparse();
    	fclose(ASM);
		fclose(debbug_out);
    	toASM("ASM_temp.txt");
    }

}
