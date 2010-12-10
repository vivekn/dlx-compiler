#include<stdio.h>


struct icode {
	unsigned opc:6;
	unsigned rs1:5;
	unsigned rd:5;
	unsigned imm:16;
};

typedef struct icode y;

main() {
//y x = {25,10,10,1000};
FILE *fp = fopen("test","rb");
//fwrite(&x,sizeof(y),1,fp);

int x1;
x1 = getw(fp);
printf("%d",x1);
}


// 25 * 2^25 + 10 * 2^20 +10 *2^15+1000
//01100101010010100000001111101000
//1699349480
