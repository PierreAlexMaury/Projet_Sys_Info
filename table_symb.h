#define maxSymb 5

struct symb{
	char* identif;
	int type; /* if 1 : var is const int type; else if 0 : var is int; else if 2: var is temp*/
	int adresse;
};

struct table_symbole{
	struct symb tab[maxSymb];
	int sommet;
};

int nb_chiffre(int nombre) ;

int nb_chiffre_rec(int nombre, int compt) ;

int initTab(void);

int addSymb(char* identif, int type);

int addTemp();

int findSymb(char* identif);

int getAddr(char* identif);

void printTabSymb(void);
