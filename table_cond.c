#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "table_cond.h"

struct table_cond tableCond = {.position = 0};

int addIf(int from){
	
	printf("**** START **** addCond\n");

	if (from < 0){
		return -1;
	}

	if (table.sommet == maxSymb){
		return -1;
	}

	struct cond cond_temp;

	cond_temp.from = from;
	cond_temp.to = -1;

	table_cond.tableCond[tableCond.position] = cond_temp;

	tableCond.position ++;

    printf("**** END **** addCond\n");

	return 0;

}