/*DLX - Compiler - Symbol & Lookup hashtables 
  By Vivek Narayanan <mail@vivekn.co.cc>
  Nov 8th 2010	*/

#include<stdlib.h>
#include<string.h>

#define K 16 // chaining coefficient

#define OPCODE 1
#define REGISTER 2
#define SYMBOL 3


char* add_prefix(int table,char * key) {
	char *prefixes[] = {"OPC_","REG_","SYM_"}; 
	char *newstr = (char *) malloc(80 * sizeof(char));
	strcpy(newstr,prefixes[table]);
	strcat(newstr,key);
	return newstr;
}

// Custom Dictionary for 8086 Assembler - (C) Vivek Narayanan 2010

struct dict
{
	char *name; /* name of key */
	int val;   /*Integer Value*/
	char type; /*Instruction Type*/
	struct dict *next; /* link field */
};

typedef struct dict dict;
dict *table[K];
int initialized = 0;

void  putval ( int , char *,int);
void  tputval ( int , char *,int,char);

void init2() {
/*Loading Code*/


}


void init_dict()
{	
	initialized = 1;
	int i;	
	for(i=0;i<K;i++)
		table[i] = (dict *)0;
	init2();
}

dict * getval (int,char *);


int hash (char *string) {
	int sum=0,m=0;
	char buf[100];
	strcpy(buf,string);
	for(m=0;buf[m]!='\0';m++)
		sum+=(int) buf[m];
	return sum%K;
}


void putval ( int table_id , char *key,int sval )
{	
	/* For inserting a key into the table with integer value */
	char * key_name = (char *) malloc(80 * sizeof(char));
	key_name = add_prefix(table_id,key);
	int hsh = hash(key_name);	
	dict *ptr;
	ptr = (dict *) malloc (sizeof(dict));
	ptr->name = (char *) malloc (strlen(key_name)+1);
	ptr->val = sval;
	strcpy (ptr->name,key_name);
		
	ptr->next = (struct dict *)table[hsh];
	table[hsh] = ptr;
	
}

void tputval ( int table_id , char *key,int sval,char stype)
{	
	/* For inserting a key into the table with character value and an integer value */
	char * key_name = (char *) malloc(80 * sizeof(char));
	key_name = add_prefix(table_id,key);
	int hsh = hash(key_name);	
	dict *ptr;
	ptr = (dict *) malloc (sizeof(dict));
	ptr->name = (char *) malloc (strlen(key_name)+1);
	ptr->val = sval;
	ptr->type = stype;
	strcpy (ptr->name,key_name);
	
	
	ptr->next = (struct dict *)table[hsh];
	table[hsh] = ptr;
	
}


dict * getval ( int table_id , char *key )
{	
	char * key_name = (char *) malloc(80 * sizeof(char));
	key_name = add_prefix(table_id,key);

	int hsh = hash(key_name);	
	dict *ptr;
	for (ptr = table[hsh]; ptr != (dict *) 0;
		ptr = (dict *)ptr->next)
	if (strcmp (ptr->name,key_name) == 0)
		return ptr;
	return (dict *) 0;
}

