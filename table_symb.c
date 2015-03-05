#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_symb.h"

struct table_symbole table = {.sommet = 0};

int addSymb(char* identif, int constant) {
	if (table.sommet == maxSymb)
		return -1;

	struct symb symb_temp;
	
	symb_temp.identif = identif;
	symb_temp.adresse = table.sommet;
	symb_temp.constant = constant;
	
	table.tab[table.sommet] = symb_temp;
	
	table.sommet ++;

	return 0;
}

/* Return 1 if var already exists, 0 if not */
int findSymb(char* identif) {
	int i = 0;
	int found = 0;
	
	while (!found && i < table.sommet) {
		if (!strcmp(table.tab[i].identif,identif)) {
			found = 1;
		} else {
			i++;
		}
	}
	
	return found;
}

void printTabSymb(void) {
	int i;
	char* constant;
	constant = malloc(sizeof(char*));
	
	for (i = 0; i < table.sommet; i++) {
	
		if (table.tab[i].constant == 0) {
			strcpy(constant,"int");
		}
		else {
			strcpy(constant,"const int");
		}
		printf("| %s | %s | %d |\n",table.tab[i].identif, constant,table.tab[i].adresse);
	}
	
	printf("\n");
}
