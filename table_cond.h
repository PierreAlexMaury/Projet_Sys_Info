#define maxCond 250

struct cond {
	int from;
	int to;
};

struct table_cond{
	struct cond[maxCond];
	int position;
};

int addIf(int from,int to);

int addWhile(int from, int to);

int fillCond(FILE file);

