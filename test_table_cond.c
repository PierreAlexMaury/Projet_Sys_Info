#include <stdio.h>
#include <stdlib.h>

#include "table_cond.h"

int main(int argc, char* argv[]) {
	char * file_name = "ASM_temp.txt";

	pushCond(4,-1);
	pushCond(-1,99999);
	pushCond(8,-1);
	pushCond(-1,99999);
	printTableCond();
	toASM(file_name);

	return 0;
}
