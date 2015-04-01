#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_cond.h"

struct table_cond tableCond = {.position = 0};

int pushIf(int from, int to){
	
	printf("**** START **** pushIf");
	
	struct cond cond_temp;

	if (from == -1 && to >= 0){
		/*On cherche à insérer une adresse d'atterissage*/
	}

	if (from >= 0 && to == -1){
		if (tableCond.position <= maxCond) {
			printf("pushIf : Table des conditions pleine\n");
		}
	}

	else {
		printf("pushIf : Parametres invalides\n");
		return -1;
	}


	table_cond.tableCond[tableCond.position] = cond_temp;

	tableCond.position ++;

    printf("**** END **** pushIf\n");

	return 0;

}
