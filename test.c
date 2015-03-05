#include <stdio.h>
#include <stdlib.h>
#include "table_symb.h"

int main(void) {
	printTabSymb();
	addSymb("a",1);
	printTabSymb();
	addSymb("b",0);
	printTabSymb();
	
 	printf("%d",findSymb("a"));
 	printf("%d",findSymb("c"));
	
	return 0;
}

