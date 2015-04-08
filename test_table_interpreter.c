#include <stdio.h>
#include <stdlib.h>

#include "table_interpreter.h"

int main(int argc, char* argv[]) {

	tab_var[0] = -65;
	tab_var[1] = 6;

	addInst(14,2,0,1);


	printTabInst();

	execute();

	printTabVar(4);

	return 0;
}