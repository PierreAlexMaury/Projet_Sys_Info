#define maxCond 250

struct cond {
	int from;
	int to;
};

struct table_cond{
	struct cond table[maxCond];
	int position;
};

int pushIf(int from,int to);

int pushCond(int from,int to);

void printTableCond();

int toASM(char * input_file);

