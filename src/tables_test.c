#include "tables.c"
#include<stdio.h>

void main () {
init_dict();
tputval(SYMBOL,"Symbol",90,'J');


dict *ptr = getval(SYMBOL,"Symbol");

printf("%s:%d:%c",ptr->name,ptr->val,ptr->type);

}
