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

int nb_chiffre(int nombre) ;

int nb_chiffre_rec(int nombre, int compt) ;

int initTab(void);

int addSymb(char* identif, int constant);

int addTemp();

int findSymb(char* identif);

void printTabSymb(void);