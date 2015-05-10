#define maxInst 1024
#define STACK_SIZE 256

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


struct struct_stack{
	int stack[STACK_SIZE];
	int SP;
};

struct struct_FP{
	int t_FP[STACK_SIZE];
	int i_FP;
};


int addInst(int code_op, int op1, int op2, int op3) ;

void printStack(int max);

void printTabInst(void);

void execute(void);


