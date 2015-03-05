#define maxSymb 250

struct symb{
	char* identif;
	int constant; /* if 1 : var is const int type; else 0 : var is int*/
	int adresse;
};

struct table_symbole{
	struct symb tab[maxSymb];
	int sommet;
};

int initTab(void);

int addSymb(char* identif, int constant);

int findSymb(char* identif);

void printTabSymb(void);
