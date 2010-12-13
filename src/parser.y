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
												
						 }
				 |MNEM_J LABEL
				 |MNEM_I REGISTER REGISTER imm
				 |LABEL MNEM_R REGISTER REGISTER REGISTER
				 |LABEL MNEM_J LABEL
				 |LABEL MNEM_I REGISTER REGISTER imm
			;												
				

imm : INT
	|CHAR
	|HEXSTR
	;


%%
