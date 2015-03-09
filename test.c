#include <stdio.h>
#include <stdlib.h>
#include "table_symb.h"

<<<<<<< Updated upstream
int main() {
    char identif1[] = "a";
    char identif2[] = "b";
    char identif3[] = "c";

    char temp1[] = "temp1";

=======
int main(void) {
	int a,b;
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
	a=addTemp();
	b=addTemp();
	printTabSymb();
	
	printf("premier add : %d , deuxième add: %d\n",a,b);
 	printf("%d",findSymb("a"));
 	printf("%d",findSymb("c"));
	
>>>>>>> Stashed changes
	return 0;
}

