/*DLX - Compiler - Code Generator 
  By Vivek Narayanan <mail@vivekn.co.cc>
  Nov 8th 2010	*/

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "tables.c"

/* File Pointer */

FILE *fp;
void cg_start() {
	fp = fopen(DEFAULT_PATH,"wb");
}

void cg_set(char *s) {
	fp = fopen(s,"wb");

}



/* Code Structures */
struct icode {
	unsigned opc:6;
	unsigned rs1:5;
	unsigned rd:5;
	unsigned imm:16;
};

struct rcode {
	unsigned opc:6;
	unsigned rs1:5;
	unsigned rs2:5;	
	unsigned rd:5;
	unsigned imm:16;
};

struct jcode {
	unsigned opc:6;
	unsigned offset:26;
};

typedef struct icode icode;
typedef struct rcode rcode;
typedef struct jcode jcode;

icode ic;
rcode rc;
jcode jc;
/* Structure Manipulation Functions */

void ibytes(icode a) {
	/*...*/
}

void rbytes(icode a) {
	/*...*/
}

void jbytes(icode a) {
	/*...*/
}

/*Type I Instructions*/
int code_type_i(char *mnem,char *rsrc , char *rdest, int imm){
	 dict *obj = getval(OPCODE,mnem);
         if(obj==(dict *) 0)
		return 0;
	 ic.opc = obj->val;
	
	 obj = getval(REGISTER,rsrc);
	 if(obj==(dict *) 0)
		return 0;
	 ic.rs1 = obj->val;
	 obj = getval(REGISTER,rdest);
	 if(obj==(dict *) 0)
		return 0;
	 ic.rd = obj->val;
	 ic.imm = imm&0xffff;
	
	
	//call ibytes which dumps/writes the bytes and returns bytes returned
	 

}
/*Type J Instructions*/
int code_type_j(char *mnem,int offset){
	 
	 obj = getval(OPCODE,mnem);
	 jc.offset =offset;	 
	 if(obj==(dict *) 0)
		return 0;
	 jc.opc = obj->val;
	
	
	//call jbytes which dumps/writes the bytes
}
/*Type R Instructions*/
int code_type_r(char *mnem,char *rsrc1 ,char *rsrc2, char *rdest){
	dict *obj = getval(OPCODE,mnem);
         if(obj==(dict *) 0)
		return 0;
	 rc.opc = obj->val;
	
	 obj = getval(REGISTER,rsrc1);
	 if(obj==(dict *) 0)
		return 0;
	 rc.rs1 = obj->val;

	 obj = getval(REGISTER,rsrc2);
	 if(obj==(dict *) 0)
		return 0;
	 rc.rs2 = obj->val;

	 obj = getval(REGISTER,rdest);
	 if(obj==(dict *) 0)
		return 0;
	 rc.rd = obj->val;
	 
	
	
	//call rbytes which dumps/writes the bytes and returns bytes returned

}
