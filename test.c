#include <stdio.h>
#include <stdlib.h>
#include "table_symb.h"

int main() {
    char identif1[] = "a";
    char identif2[] = "b";
    char identif3[] = "c";

    char temp1[] = "temp1";

	printTabSymb();
	addSymb(identif1,1);
	printTabSymb();
	addSymb(identif2,0);
	printTabSymb();
    printf("temp1 is at the address %d\n",addTemp());
    printTabSymb();
    printf("temp2 is at the address %d\n",addTemp());
    printTabSymb();
    printf("temp3 is at the address %d\n",addTemp());
    printTabSymb();
    printf("temp4 is at the address %d\n",addTemp());
    printTabSymb();

    printf("find temp2 = %d\n",findSymb("temp2"));
    printf("find a = %d\n",findSymb("a"));
    printf("find c = %d\n",findSymb("c"));

    printf("temp1 is at the address %d\n", getAddr(temp1));
    printf("%s is at the address %d\n",identif1,getAddr(identif1));
    printf("%s is at the address %d\n",identif2,getAddr(identif2));
    printf("%s is at the address %d\n",identif3,getAddr(identif3));

    clearTemp();
    printTabSymb();

    addSymb(identif3,0);
	printTabSymb();
	return 0;
}

