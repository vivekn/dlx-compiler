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

char *MNEM,*OP1,*OP2;

void init_tokens1(char *id) {
	int l = strlen(id);
	MNEM = (char *) malloc( 20 * l);
	strcpy(MNEM,id);
	
}

void init_tokens2(char *id1,char *id2) {
	
	int l = strlen(id1)+1;
	MNEM = (char *) malloc( 20 * l);
	OP1    = (char *) malloc(20 * l);
	char *buf1 = (char *) malloc(20 * l);
	buf1 = strtok(id1," ");
	strcpy(MNEM,buf1);
	strcpy(OP1,id2);
	

}

void init_tokens3(char *id1,char *id2,char *id3) {
	int l = strlen(id1);
	MNEM = (char *) malloc( 20 * l);
	OP1    = (char *) malloc(20 * l);
	OP2    = (char *) malloc(20 * l);
	char *buf1 = (char *) malloc(20 * l);
	buf1 = strtok(id1," ");
	strcpy(MNEM,buf1);
	buf1 = strtok(id2,",");
	strcpy(OP1,buf1);
	strcpy(OP2,id3);


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




