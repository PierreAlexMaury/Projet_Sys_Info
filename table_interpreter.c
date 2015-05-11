#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_interpreter.h"

struct table_inst table = {.PC = 0};
struct struct_stack str_stack ;
struct struct_FP str_FP = {.i_FP = 0};


int addInst(int code_op, int op1, int op2, int op3) {
	/*Si la table est pleine */
	if (table.PC >= maxInst) {
		printf("Erreur: table interpreter pleine\n");
		return -1;
	}

	/*Si le code operation est invalide*/
	if (code_op <= 0 || code_op > 17) {
		printf("Erreur: code_op invalide\n");
		return -1;
	}

	if (table.PC == 0) {
		int i ;
		for (i = 1; i < maxInst; i++) {
			table.tab[i].code_op = 0;
		}
	}

	table.tab[table.PC].code_op = code_op;
	table.tab[table.PC].op1 = op1;
	table.tab[table.PC].op2 = op2;
	table.tab[table.PC].op3 = op3;

	table.PC++;

	return 1;
}

void execute(void) {
	int finished = 0;
	int max = table.PC;
	int * stack0 = &(str_stack.stack[0]);
	int temp;
	int arg;
	int retour;
	int retour_pop;

	int code_op, op1, op2, op3;

	if (table.PC != 0) {

		table.PC = 0;
	
		while (! finished) {

			code_op = table.tab[table.PC].code_op;
			op1 = table.tab[table.PC].op1;
			op2 = table.tab[table.PC].op2;
			op3 = table.tab[table.PC].op3;

			// printf("PC: %d et code_op : %d %d %d\n", table.PC+1, code_op, op1, op2);
			// printStack(12);

			switch (code_op) {
				case 1: /* ADD op1 op2 op3 */
					str_stack.stack[str_stack.SP + op1 ] = str_stack.stack[str_stack.SP + op2] + str_stack.stack[str_stack.SP + op3];
					table.PC++;
					break;

				case 2: /* MUL op1 op2 op3 */
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2] * str_stack.stack[str_stack.SP + op3];
					table.PC++;
					break;

				case 3: /* LESS op1 op2 op3 */
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2] - str_stack.stack[str_stack.SP + op3];
					table.PC++;
					break;

				case 4: /* DIV op1 op2 op3 */
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2] / str_stack.stack[str_stack.SP + op3];
					table.PC++;
					break;


				case 5: /* COP op1 op2 */
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2];
					table.PC++;
					break;

				case 6: /* AFC op1 op2 */
					str_stack.stack[str_stack.SP + op1] = op2;
					table.PC++;
					break;

				case 7: /* JMP op1 */ 
					table.PC = op1-1; 
					break;

				case 8: /* JMF op1 op2 */
					if(str_stack.stack[str_stack.SP + op1] == 0)
						table.PC = op2-1; 
					else
						table.PC++;

					break;

				case 9: /* INF op1 op2 op3 */
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2] < str_stack.stack[str_stack.SP + op3];
					table.PC++;
					break;

				case 10: /* SUP op1 op2 op3 */
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2] > str_stack.stack[str_stack.SP + op3];
					table.PC++;
					break;

				case 11: /* EQU op1 op2 op3 */
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2] == str_stack.stack[str_stack.SP + op3];
					table.PC++;
					break;

				case 12: /* PRI op1 */
					printf("%d\n",str_stack.stack[str_stack.SP + op1]);
					table.PC++;
					break;

				case 13: /* LEQ op1 op2 op3 */
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2] <= str_stack.stack[str_stack.SP + op3];
					table.PC++;
					break;

				case 14: /* SEQ op1 op2 op3*/
					str_stack.stack[str_stack.SP + op1] = str_stack.stack[str_stack.SP + op2] >= str_stack.stack[str_stack.SP + op1];
					table.PC++;
					break;

				case 15: /* PUSH op1 op2 */
					arg = str_stack.stack[str_stack.SP + op1];
					/*On pointe notre SP au dessus des variables locales de la fonction appellante*/
					str_stack.SP += op2;
					/*On pointe sur l'argument*/
					//str_stack.SP++;
					/* on push l'argument*/
					str_stack.stack[str_stack.SP] = arg;
					/* on pointe sur le return */
					str_stack.SP++;
					/* on pointe sur l'adresse de retour */
					str_stack.SP++;
					/* on incrémente l'indice de la tables des FP*/
					str_FP.i_FP++;
					/* on sauvegarde le SP dans la tables des FP */
					str_FP.t_FP[str_FP.i_FP] = str_stack.SP;
					/* on push l'adresse de retour PC + 1 */
					str_stack.stack[str_stack.SP] = table.PC+1; 
				 	/* on pointe vers la première variable */
				 	str_stack.SP++;
				 	/* on push notre argument */
				 	str_stack.stack[str_stack.SP] = arg;
				 	table.PC++;
				 	break;

				case 16: /* EOF op1 */
				 	/* on sauvegarde temporairement le retour */
				 	retour = str_stack.stack[str_stack.SP + op1];
					/* on pointe sur l'adresse de retour */
					str_stack.SP--;
					/* on pop PC pour retomber  au bon endroit dans la fonction appelante*/
					table.PC = str_stack.stack[str_stack.SP];
					/* on pointe sur le return */
					str_stack.SP--;
					/* on met le retour dans la case retour */
					str_stack.stack[str_stack.SP] = retour;
					
					table.PC++;
					break;


				case 17: /* POP op1 */
					/* on sauvegarde temporairement le retour de la pile */
					retour_pop = str_stack.stack[str_stack.SP];
					/* On décrémente l'indice de la table des FP */
					str_FP.i_FP--;
				 	/* On met SP à FP[i] */
					str_stack.SP = str_FP.t_FP[str_FP.i_FP];
					/* on met le retour dans la variale souhaitee */
					str_stack.stack[str_stack.SP + op1] = retour;
					
					table.PC++;
					break;

				default:
					finished = 1;
					break;
			}
			
			if (table.PC >= max) {
				finished = 1;
			}


		}

	}
}

void printStack(int max) {
	int i;

    printf("--------\n");
	for (i = 0; i < max; i++) {
		printf("| %d |\n",str_stack.stack[i]);
	}
	printf("--------\n");

	printf("\n");
}

void printTabInst(void) {
	int i;
	printf("-------------------- Table Instructions ------------------\n\n");
    printf("--------------------\n");
    char * nom;

	for (i = 0; i < table.PC; i++) {
		switch (table.tab[i].code_op) {
				case 1:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"ADD");
					break;

				case 2:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"MUL");
					break;

				case 3:
					nom = malloc(4*sizeof(char));
					strcpy(nom,"LESS");
					break;

				case 4:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"DIV");
					break;

				case 5:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"COP");
					break;

				case 6:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"AFC");
					break;

				case 7:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"JMP");
					break;

				case 8:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"JMF");
					break;

				case 9:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"INF");
					break;

				case 10:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"SUP");
					break;

				case 11:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"EQU");
					break;

				case 12:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"PRI");
					break;

				case 13:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"LEQ");
					break;

				case 14:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"SEQ");
					break;

				case 15:
					nom = malloc(4*sizeof(char));
					strcpy(nom,"PUSH");
					break;

				case 16:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"EOF");
					break;

				case 17:
					nom = malloc(3*sizeof(char));
					strcpy(nom,"POP");
					break;

				default:
					break;
			}
		printf("| %s | %d | %d | %d |\n",nom, table.tab[i].op1, table.tab[i].op2, table.tab[i].op3);
	}
	printf("--------------------\n\n");
}