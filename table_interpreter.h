#define maxInst 1024
#define maxVar 256

struct inst{
	int code_op;
	int op1;
	int op2;
	int op3;
};

struct table_inst{
	struct inst tab[maxInst];
	int PC;
};

int tab_var[maxVar];



int addInst(int code_op, int op1, int op2, int op3) ;

void printTabVar(int max);

void printTabInst(void);

void execute(void);


