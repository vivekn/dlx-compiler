%union {  

  int     intval;   
  char    *id;     
  
}

%token COMMENT NEWLINE
%token COMMA REGISTER MEMADDR CHAR INT HEXSTR
%token MNEM_R MNEM_I MNEM_J LABEL
%start program


%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "codegen.c"
int bytectr,unresolved;

int chk_unres() {
fseek(fp,0,0);

return unresolved;
}


int get_ctr() {return bytectr;}
void reset_byte() {
	
	bytectr=0;
}

void reset_unres() {
	unresolved=0;
}

char **MNEM;

void init_tokens(char *id) {
	/*Function to split a line into words*/
	
	MNEM = (char **) calloc(5,20);
	int i;	
	
	for(i = 0;i<5;i++) 
		MNEM[i] = (char *) calloc(20,1);	
	i=0;	
	char *temp = (char *) calloc(20,1);
	temp = strtok(id," ");
	while(temp) {
		MNEM[i] = temp;
		temp = strtok(NULL," ");	
	}
	
}


%}

%%

program:  program instruction 
		 |		
		;

instruction : MNEM_R REGISTER REGISTER REGISTER	{ 
						init_tokens($<id>1);
						byte_ctr += code_type_r(MNEM[0],MNEM[1],MNEM[2],MNEM[3]);	
						 }
				 |MNEM_J LABEL	{
				 		/* Searches for the label in the symbol table , if found executes code */
				 		init_tokens($<id>1);
				 		dict *obj = getval(SYMBOL,MNEM[1]);
				 		if (obj==(dict *) 0)
				 			unresolved++;
				 		else
				 			byte_ctr += code_type_j(MNEM[0],(obj->val) - byte_ctr);	
						}
				 		
				 |MNEM_I REGISTER REGISTER imm	{
				 		init_tokens($<id>1);
						byte_ctr += code_type_i(MNEM[0],MNEM[1],MNEM[2],atoi(MNEM[3]));	
						}
				 |LABEL MNEM_R REGISTER REGISTER REGISTER  {
						/*Insert label in symbol table,then execute code*/
						init_tokens($<id>1);						
						putval(SYMBOL,atoi(MNEM[0]));
						byte_ctr += code_type_r(MNEM[1],MNEM[2],MNEM[3],MNEM[4]);	
						}
				 |LABEL MNEM_I REGISTER REGISTER imm	{
						/*Insert label in symbol table,then execute code*/
						init_tokens($<id>1);						
						putval(SYMBOL,atoi(MNEM[0]));
						byte_ctr += code_type_i(MNEM[1],MNEM[2],MNEM[3],atoi(MNEM[4]));	
						}
				|LABEL MNEM_J LABEL {
						/*Insert label in symbol table,then search for label, if found - execute code*/
						init_tokens($<id>1);						
						putval(SYMBOL,atoi(MNEM[0]));
						dict *obj = getval(SYMBOL,MNEM[1]);
				 		if (obj==(dict *) 0)
				 			unresolved++;
				 		else
				 			byte_ctr += code_type_j(MNEM[0],(obj->val) - byte_ctr);	
						}

			;												
				

imm : INT
	|CHAR
	|HEXSTR
	;


%%
