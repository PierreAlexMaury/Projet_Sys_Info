#include <stdio.h>
#include <stdlib.h>
#include "table_symb.h"

extern 

int main(void) {

    addSymb("a",1,0);

    createTable();
    createTable();
    createTable();



    addSymb("a",1,0);
    addSymb("d",1,0);
    addSymb("e",1,1);

    printf("after creates\n");

    nommerTable(0,"main");
    nommerTable(1,"fonction1");
    nommerTable(2,"fonction2");

    setLineASM(1,30);
    setLineASM(2,60);

    printf("size : %d\n",getNumTable("fonction1"));
    printf("size : %d\n",getNumTable("fonction2"));
    printf("size : %d\n",getNumTable("main"));
    printf("size : %d\n",getNumTable("fonction3"));


    printTabSymb(0);
    printTabSymb(1);
    printTabSymb(2);

	/*printTabSymb();
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

	a=addTemp();
	b=addTemp();
	printTabSymb();
	
	printf("premier add : %d , deuxième add: %d\n",a,b);
 	printf("%d",findSymb("a"));
 	printf("%d",findSymb("c"));*/
	
	return 0;
}

