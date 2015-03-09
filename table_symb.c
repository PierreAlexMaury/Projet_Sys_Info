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
    printf("**** START **** addSymb\n");

	if (table.sommet == maxSymb)
		return -1;

	struct symb symb_temp;

	symb_temp.identif = identif;
	symb_temp.adresse = table.sommet;
	symb_temp.type = type;

	table.tab[table.sommet] = symb_temp;

	table.sommet ++;

    printf("**** END **** addSymb\n");

	return 0;
}

int addTemp() {
    printf("**** START **** addTemp\n");

	if (table.sommet == maxSymb) {
		printf("addTemp : Erreur, table des symbole pleine");
		return -1;
	}
	
	struct symb symb_temp;

	symb_temp.identif = malloc(sizeof(char)*(4+nb_chiffre(table.sommet)));
    sprintf(symb_temp.identif,"temp%d",table.sommet);
	symb_temp.adresse = table.sommet;
	symb_temp.type = 2;

	table.tab[table.sommet] = symb_temp;

	table.sommet ++;

	printf("**** END **** addTemp\n");

	return table.sommet - 1;
}

/* Return 1 if var already exists, 0 if not */
int findSymb(char* identif) {
	int i = 0;
	int found = 0;

	printf("**** START **** findSymb\n");

	while (!found && i < table.sommet) {
		if (!strcmp(table.tab[i].identif,identif) && table.tab[i].type != 2) {
			found = 1;
		} else {
			i++;
		}
	}

	printf("**** END **** findSymb\n");

	return found;
}


int getAddr(char* identif) {
  	int index = table.sommet-1;
	int addr = -1;

    printf("**** START **** getAddr\n");

	while (addr == -1 && index >= 0) {
		if(strcmp(table.tab[index].identif,identif) == 0 && table.tab[index].type != 2) {
			addr = index;
		} else {
			index--;
		}

	}

	printf("**** END **** getAddr\n");

	return addr;
}

void clearTemp() {
    int index = table.sommet-1;
    int others = 1;

    printf("**** START **** clearTemp\n");

    while (others == 1 && index >= 0) {
        if (table.tab[index].type == 2) {
            table.sommet--;
            index--;
        }
        else {
            others = 0;
        }
    }

    printf("**** END **** clearTemp\n");
}


void printTabSymb(void) {
	int i;

    printf("-------------\n");
	for (i = 0; i < table.sommet; i++) {
		printf("| %s | %d | %d |\n",table.tab[i].identif, table.tab[i].type,table.tab[i].adresse);
	}
	printf("-------------\n");

	printf("\n");
}


