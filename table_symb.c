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
    return 0;
}

int addSymb(char* identif, int type) {

	if (table.sommet == maxSymb)
		return -1;

	struct symb symb_temp;

	symb_temp.identif = identif;
	symb_temp.adresse = table.sommet;
	symb_temp.type = type;

	table.tab[table.sommet] = symb_temp;

	table.sommet ++;

	return 0;
}

int addTemp() {

	if (table.sommet == maxSymb) {
		printf("\naddTemp : Erreur, table des symbole pleine\n");
		return -1;
	}
	
	struct symb symb_temp;

	symb_temp.identif = malloc(sizeof(char)*(4+nb_chiffre(table.sommet)));
    sprintf(symb_temp.identif,"temp%d",table.sommet);
	symb_temp.adresse = table.sommet;
	symb_temp.type = 2;

	table.tab[table.sommet] = symb_temp;

	table.sommet ++;

	return table.sommet - 1;
}

/* Return 1 if var already exists, 0 if not */
int findSymb(char* identif) {
	int i = 0;
	int found = 0;

	while (!found && i < table.sommet) {
		if (!strcmp(table.tab[i].identif,identif) && table.tab[i].type != 2) {
			found = 1;
		} else {
			i++;
		}
	}

	return found;
}


int getAddr(char* identif) {
  	int index = table.sommet-1;
	int addr = -1;

	while (addr == -1 && index >= 0) {
		if(strcmp(table.tab[index].identif,identif) == 0 && table.tab[index].type != 2) {
			addr = index;
		} else {
			index--;
		}

	}

	return addr;
}

void clearTemp() {
    int index = table.sommet-1;
    int others = 1;

    while (others == 1 && index >= 0) {
        if (table.tab[index].type == 2) {
            table.sommet--;
            index--;
        }
        else {
            others = 0;
        }
    }

}


void printTabSymb(void) {
	int i;

	printf("-------------------- Table Symboles ----------------------\n\n");

    printf("-------------\n");
	for (i = 0; i < table.sommet; i++) {
		printf("| %s | %d | %d |\n",table.tab[i].identif, table.tab[i].type,table.tab[i].adresse);
	}
	printf("-------------\n\n");
}


