#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_interpreter.h"

struct table_inst table = {.PC = 0};


int addInst(int code_op, int op1, int op2, int op3) {
	/*Si la table est pleine */
	if (table.PC >= maxInst) {
		printf("Erreur: table interpreter pleine\n");
		return -1;
	}

	/*Si le code operation est invalide*/
	if (code_op <= 0 || code_op >= 15) {
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

	if (table.PC != 0) {

		table.PC = 0;

		while (! finished) {

			switch (table.tab[table.PC].code_op) {
				case 1:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) + *(&tab_var[0]+table.tab[table.PC].op3);
					table.PC++;
					break;

				case 2:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) * (*(&tab_var[0]+table.tab[table.PC].op3));
					table.PC++;
					break;

				case 3:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) - (*(&tab_var[0]+table.tab[table.PC].op3));
					table.PC++;
					break;

				case 4:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) / (*(&tab_var[0]+table.tab[table.PC].op3));
					table.PC++;
					break;

				case 5:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2);
					table.PC++;
					break;

				case 6:
					*(&tab_var[0]+table.tab[table.PC].op1) = table.tab[table.PC].op2;
					table.PC++;
					break;

				case 7:
					table.PC = table.tab[table.PC].op1-1; 
					break;

				case 8:
					if(*(&tab_var[0]+table.tab[table.PC].op1) == 0)
						table.PC = table.tab[table.PC].op2-1; 
					else
						table.PC++;

					break;

				case 9:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) < *(&tab_var[0]+table.tab[table.PC].op3);
					table.PC++;
					break;

				case 10:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) > *(&tab_var[0]+table.tab[table.PC].op3);
					table.PC++;
					break;

				case 11:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) == *(&tab_var[0]+table.tab[table.PC].op3);
					table.PC++;
					break;

				case 12:
					printf("%d\n",*(&tab_var[0]+table.tab[table.PC].op1) );
					table.PC++;
					break;

				case 13:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) <= *(&tab_var[0]+table.tab[table.PC].op3);
					table.PC++;
					break;

				case 14:
					*(&tab_var[0]+table.tab[table.PC].op1) = *(&tab_var[0]+table.tab[table.PC].op2) >= *(&tab_var[0]+table.tab[table.PC].op3);
					table.PC++;
					break;

				default:
					finished = 1;
					break;
			}
			
			if (table.PC >= max)
				finished = 1;


		}
	}
}

void printTabVar(int max) {
	int i;

    printf("--------\n");
	for (i = 0; i < max; i++) {
		printf("| %d |\n",tab_var[i]);
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

				default:
					break;
			}
		printf("| %s | %d | %d | %d |\n",nom, table.tab[i].op1, table.tab[i].op2, table.tab[i].op3);
	}
	printf("--------------------\n\n");
}