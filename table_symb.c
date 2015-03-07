#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_symb.h"

struct table_symbole table = {.sommet = 0};

int nb_chiffre(int nombre) {
    if (nombre < 9)
        return 1;
        return nb_chiffre_rec(nombre,0);
}

int nb_chiffre_rec(int nombre, int compt) {
    if (nombre != 0) {
        nb_chiffre_rec(nombre/10,compt+1);
    }
    else {
        return compt;
    }
}

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

int addTemp() {
	if (table.sommet == maxSymb)
		return -1;

	struct symb symb_temp;

	symb_temp.identif = malloc(sizeof(char)*(4+nb_chiffre(table.sommet)));
    sprintf(symb_temp.identif,"temp%d",table.sommet);
	symb_temp.adresse = table.sommet;
	symb_temp.constant = 2;

	table.tab[table.sommet] = symb_temp;
	
	table.sommet ++;

	return table.sommet - 1;
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


/*int getAddr(char* identif) {

}*/

void printTabSymb(void) {
	int i;
	char* constant;
	constant = malloc(sizeof(char*));
	
	for (i = 0; i < table.sommet; i++) {
	
		if (table.tab[i].constant == 0) {
			strcpy(constant,"int");
		}
		else if (table.tab[i].constant == 1) {
			strcpy(constant,"const int");
		}
		else {
			strcpy(constant,"temp");
		}
		printf("| %s | %s | %d |\n",table.tab[i].identif, constant,table.tab[i].adresse);
	}
	
	printf("\n");
}


