%union {  

  int     intval;   
  char    *id;     
  
}

%token COMMENT NEWLINE
%token COMMA REGISTER MEMADDR CHAR INT HEXSTR
%token MNEMONIC JUMP LABEL LABELR ZEROP ONEOP
%start program


%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "cg2.c"
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

instruction : LABEL MNEMONIC REGISTER COMMA REGISTER	{	init_tokens3($<id>2,$<id>3,$<id>5);
														char a[40] = "jxl_";
													strcat(a,MNEM);
													putval(a,bytectr);
													init_tokens3($<id>2,$<id>3,$<id>5);
													
													
														bytectr+= code_2op(MNEM,OP1,OP2);//2OP REG REG
													}		
			|LABEL MNEMONIC REGISTER COMMA imm		{init_tokens2($<id>1,$<id>2);
													char a[40] = "jxl_";
													strcat(a,MNEM);
													putval(a,bytectr);
													init_tokens3($<id>2,$<id>3,$<id>5);
													
													 bytectr+= code_2op_reg_imm(MNEM,OP1,atoi(OP2));//2 OP REG IMM
												}
			|LABEL MNEMONIC REGISTER COMMA MEMADDR {init_tokens2($<id>1,$<id>2);
													char a[40] = "jxl_";
													strcat(a,MNEM);
													putval(a,bytectr);	init_tokens3($<id>2,$<id>3,$<id>5);//2 OP REG MEM
														 bytectr+= code_2op_reg_mem(MNEM,OP1,OP2);}
			|LABEL MNEMONIC MEMADDR COMMA REGISTER {init_tokens2($<id>1,$<id>2);
													char a[40] = "jxl_";
													strcat(a,MNEM);
													putval(a,bytectr);init_tokens3($<id>2,$<id>3,$<id>5);// 2OP REG MEM
													bytectr+=  code_2op_mem_reg(MNEM,OP1,OP2);}
			|LABEL ONEOP  MEMADDR					{init_tokens2($<id>1,$<id>2);
													char a[40] = "jxl_";
													strcat(a,MNEM);
													putval(a,bytectr);init_tokens2($<id>2,$<id>3);//1 op mem
														 bytectr+= code_1op_mem(MNEM,OP1);
														}			
			|LABEL ONEOP imm							{init_tokens2($<id>1,$<id>2);
													char a[40] = "jxl_";
													strcat(a,MNEM);
													putval(a,bytectr);init_tokens2($<id>2,$<id>3);//1 op imm
													bytectr+=code_1op_imm(MNEM,OP1);																
														}			
			|LABEL ONEOP  REGISTER						{init_tokens2($<id>1,$<id>2);
													char a[40] = "jxl_";
													strcat(a,MNEM);
													putval(a,bytectr);init_tokens2($<id>2,$<id>3);
													  bytectr+= code_1op(MNEM,OP1);			//1 op reg
														}
						
			|LABEL ZEROP								{init_tokens2($<id>1,$<id>2);
													char a[40] = "jxl_";
													strcat(a,MNEM);
													putval(a,bytectr);init_tokens1($<id>2);
													   bytectr+= code_0op(MNEM);//0 op
																	}			
					
			|JUMP LABEL								{    
														char a[40] = "jxl_";
														int res = getval(strcat(a,$<id>2));
														if(res!=-1){
															
															unresolved--;
															bytectr+=code_jump(MNEM,res-bytectr);
															//call jump code fn with param = res-bytectr														
															}
														else{unresolved++;}
														}
			|MNEMONIC REGISTER COMMA REGISTER	{	init_tokens3($<id>1,$<id>2,$<id>4);
													
														bytectr+= code_2op(MNEM,OP1,OP2);//2OP REG REG
													}		
			|MNEMONIC REGISTER COMMA imm		{
													init_tokens3($<id>1,$<id>2,$<id>4);
													
													 bytectr+= code_2op_reg_imm(MNEM,OP1,atoi(OP2));//2 OP REG IMM
												}
			|MNEMONIC REGISTER COMMA MEMADDR {	init_tokens3($<id>1,$<id>2,$<id>4);//2 OP REG MEM
														 bytectr+= code_2op_reg_mem(MNEM,OP1,OP2);}
			|MNEMONIC MEMADDR COMMA REGISTER {init_tokens3($<id>1,$<id>2,$<id>4);// 2OP REG MEM
													bytectr+=  code_2op_mem_reg(MNEM,OP1,OP2);}
			|ONEOP MEMADDR					{      
                                                                                                                 init_tokens2($<id>1,$<id>2);//1 op mem
														 														
														 bytectr+= code_1op_mem(MNEM,OP1);
																												
														}			
			|ONEOP imm							{init_tokens2($<id>1,$<id>2);//1 op imm
													  bytectr+= code_1op_imm(MNEM,OP1);																
														}					
			|ONEOP REGISTER 				{
													  init_tokens2($<id>1,$<id>2);
													  bytectr+= code_1op(MNEM,OP1);			//1 op reg
														}
				
			|ZEROP								{init_tokens1($<id>1);
													   bytectr+= code_0op(MNEM);//0 op
																	}
			
			;												
				

imm : INT
	|CHAR
	|HEXSTR
	;


%%




