int fonction2() {
	int a = 1;
	printf(a);
}

int fonction1() {
	int a = 2;
	fonction2();
	printf(a);
}

main() { 
	int a = 3;

	fonction1();
	printf(a);


	// int a;
	// int b;
	// int c;
	
	// a = 3;
	// printf(a);
	// printf(b);
	// printf(a);
	
	//fonction1();
	//if(a == 1)
	//	a=2;
		//fonction2();
 }
