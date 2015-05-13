#define maxSymb 250

struct symb{
	char* identif;
	int type; /* if 1 : var is const int type; else if 0 : var is int; else if 2: var is temp*/
	int adresse;
};

struct table_symbole{
	struct symb tab[maxSymb];
	int sommet;
	int max_size;
	char * nom;
	int line_ASM;
	int arg;
};

int setLineASM(int table_num, int line);

int setArg(int table_num, int arg);

int getLineASM(char * nom);

int getArg(char * nom);

int getSizeTable(char * nom);

int getSizeTableFromNum(int num);

int getNumTable(char * nom);

int getTypeSymb (char* identif, int table_num);

int nommerTable(int table_num, char * nom);

int table_exist(int num_table);

int createTable();

int nb_chiffre(int nombre) ;

int nb_chiffre_rec(int nombre, int compt) ;

int addSymb(char* identif, int type, int table_num);

int addTemp(int table_num);

int findSymb(char* identif, int table_num);

int getAddr(char* identif, int table_num);

void clearTemp(int table_num);

void printTabSymb(int table_num);
