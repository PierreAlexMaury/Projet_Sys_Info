#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_symb.h"

struct table_symbole table = {.sommet = 0};

struct table_symbole * tables;
int nb_tables = 0;

int setLineASM(int table_num, int line) {
	if (!table_exist(table_num) && line >= 0)
		return -1;

	tables[table_num].line_ASM = line;

	return 0;
}

int getLineASM(char * nom) {
	int i;
	int found;

	found = 0;
	i = 0;
	while (!found && i < nb_tables) {
		if (strcmp(tables[i].nom,nom) == 0) {
			found = 1;
		}
		else
			i++;
	}

	if (!found)
		return -1;

	return tables[i].line_ASM;
}

int nommerTable(int table_num, char * nom) {
	if (!table_exist(table_num))
		return -1;

	tables[table_num].nom = nom;

	return 0;
}

int table_exist(int num_table) {
	if (nb_tables <= num_table) {
		printf("table_symb: Erreur : table %d does not exist\n",num_table);
		return 0;
	}
	else return 1;
}

int createTable() {
	struct table_symbole new_table = {.sommet = 0};
	struct table_symbole * tables_temp = malloc((nb_tables+1)*sizeof(struct table_symbole));
	int i;

	for (i=0; i < nb_tables; i++) {
		tables_temp[i] = tables[i];
	}

	tables_temp[nb_tables] = new_table;

	tables = tables_temp;
	tables_temp = NULL;

	nb_tables++;

	return 0;
}

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

int addSymb(char* identif, int type, int table_num) {

	if (!table_exist(table_num))
		return -1;

	if (tables[table_num].sommet == maxSymb)
		return -1;

	struct symb symb_temp;

	symb_temp.identif = identif;
	symb_temp.adresse = tables[table_num].sommet;
	symb_temp.type = type;

	tables[table_num].tab[tables[table_num].sommet] = symb_temp;

	tables[table_num].sommet ++;

	return 0;
}

int addTemp(int table_num) {

	if (!table_exist(table_num))
		return -1;

	if (tables[table_num].sommet == maxSymb) {
		printf("\naddTemp : Erreur, table des symbole pleine\n");
		return -1;
	}
	
	struct symb symb_temp;

	symb_temp.identif = malloc(sizeof(char)*(4+nb_chiffre(tables[table_num].sommet)));
    sprintf(symb_temp.identif,"temp%d",tables[table_num].sommet);
	symb_temp.adresse = tables[table_num].sommet;
	symb_temp.type = 2;

	tables[table_num].tab[tables[table_num].sommet] = symb_temp;

	tables[table_num].sommet ++;

	return tables[table_num].sommet - 1;
}

/* Return 1 if var already exists, 0 if not */
int findSymb(char* identif, int table_num) {
	int i = 0;
	int found = 0;

	if (!table_exist(table_num))
		return -1;

	while (!found && i < tables[table_num].sommet) {
		if (!strcmp(tables[table_num].tab[i].identif,identif) && tables[table_num].tab[i].type != 2) {
			found = 1;
		} else {
			i++;
		}
	}

	return found;
}


int getAddr(char* identif, int table_num) {
  	int index = tables[table_num].sommet-1;
	int addr = -1;

	if (!table_exist(table_num))
		return -1;

	while (addr == -1 && index >= 0) {
		if(strcmp(tables[table_num].tab[index].identif,identif) == 0 && tables[table_num].tab[index].type != 2) {
			addr = index;
		} else {
			index--;
		}

	}

	return addr;
}

void clearTemp(int table_num) {
    int index = tables[table_num].sommet-1;
    int others = 1;

    if (table_exist(table_num)) {
	    while (others == 1 && index >= 0) {
	        if (tables[table_num].tab[index].type == 2) {
	            tables[table_num].sommet--;
	            index--;
	        }
	        else {
	            others = 0;
	        }
	    }
	}

}


void printTabSymb(int table_num) {
	int i;

	if (table_exist(table_num)) {
		if (tables[table_num].nom != NULL)
			printf("-------------------- Table Symboles %s ----------------------\n\n",tables[table_num].nom);
		else
			printf("-------------------- Table Symboles %d ----------------------\n\n",table_num);

	    printf("-------------\n");
		for (i = 0; i < tables[table_num].sommet; i++) {
			printf("| %s | %d | %d |\n",tables[table_num].tab[i].identif, tables[table_num].tab[i].type,tables[table_num].tab[i].adresse);
		}
		printf("-------------\n\n");
	}
}


