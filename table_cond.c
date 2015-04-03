#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "table_cond.h"

struct table_cond tableCond = {.position = 0};

int pushCond(int from, int to){
	
	printf("**** START **** pushCond\n");
	
	struct cond cond_temp;

	if (from == -1 && to > 0){
		int found = 0;
		int i = tableCond.position - 1;;
		while (i >= 0 && found == 0) {
			if (tableCond.table[i].to == -1) {
				found = 1;
				tableCond.table[i].to = to;
			}
			else
				i--;
		}

		if (i < 0) {
			printf("pushCond : Impossible de trouver le to à completer\n");
			return -1; /*ERREUR*/
		}
	}
	else if (from > 0 && to == -1){

		/*Si la pile est pleine: ERREUR*/
		if (tableCond.position == maxCond) {
			printf("pushCond : push dans une table des conditions pleine\n");
			return -1; /*ERREUR*/
		}


	if (from >= 0 && to == -1){
		if (tableCond.position <= maxCond) {
			printf("pushCond : Table des conditions pleine\n");
		}
	}

	else {
		printf("pushCond : Parametres invalides\n");
		return -1;
	}

		/*Si on insère un saut vers une ligne antérieur à la précédente*/
		if (tableCond.position > 0 && tableCond.table[tableCond.position-1].from >= from) {
			printf("pushCond : Tentative d'un push vers une ligne antérieure\n");
			return -1; /*ERREUR*/
		}

		cond_temp.to = -1;
		cond_temp.from = from;

		tableCond.table[tableCond.position] = cond_temp;
		tableCond.position++;
	}
	else {
		printf("pushCond : Parametres invalides\n");
		return -1;
	}

    printf("**** END **** pushCond\n");

	return 0;

}

void printTableCond() {
	int i;


    printf("**** END **** pushCond\n");

	for (i = tableCond.position - 1; i >= 0; i--) {
		if (tableCond.table[i].from == -1)
			printf("| - | %d |\n", tableCond.table[i].to);
		else if (tableCond.table[i].to == -1)
			printf("| %d | - |\n",tableCond.table[i].from);
		else
			printf("| %d | %d |\n",tableCond.table[i].from, tableCond.table[i].to);
	}
	printf("---------\n");
}

int toASM(char * file_name) {
	FILE * input_file = fopen(file_name,"r");
	FILE * output_file = fopen("ASM.txt","w+");

	int i;
	int line = 1;
	char c;

	for (i = 0; i < tableCond.position; i++) {
		while (line < tableCond.table[i].from) {
			c = fgetc(input_file);
			while (c != '\n') {
				fputc(c,output_file);
				c = fgetc(input_file);
			}
			fputc('\n',output_file);
			line++;
		}
		c = fgetc(input_file);
		while (c != '?') {
			/* Si on trouve une fin de ligne sans trouver de '?'*/
			if (c == '\n') {
				printf("Fin de ligne atteind sans trouver de '?'\n");
				return -1;
			}

			fputc(c,output_file);
			c = fgetc(input_file);
	
		}
	
		fprintf(output_file,"%d",tableCond.table[i].to);
		
		c = fgetc(input_file);
		while (c != '\n') {
			fputc(c,output_file);
			c = fgetc(input_file);
		}
		fputc('\n',output_file);

		line++;
	}
    
    c = fgetc(input_file);
	while (c != -1) {
		fputc(c,output_file);
		c = fgetc(input_file);
	}

	fclose(input_file);
	fclose(output_file);

	return 0;
}
