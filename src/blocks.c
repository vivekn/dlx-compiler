/* Basic blocks optimization using topological sorting */

#include<stdio.h>

#define BLOCK_SIZE 6

/* Structure for instructions */
struct instruction {
  int source1,source2,dest,line_no;
};

typedef struct instruction instruction;

/* Define Stack */
instruction stack[BLOCK_SIZE];
int current_pos = 0;

void addToStack(instruction I) {
  /* Get stack status and add instruction to it, call optimizer if limit reached */
  if (current_pos >= BLOCK_SIZE) 
    optimize();
  else 
    stack[current_pos++] = I;
}

int getStackInfo() {
  /* Get number of instructions in the stack  */
  return current_pos;
}

void optimize() {
  /* Optimize code according to a topological sort  */
}

void tsort() {
  /* Perform a topological sort on the stack */
}

int checkDependency(instruction A,instruction B) {
  /* Check for the following dependencies between 2 instructions: */
  
  /*find which instruction appears first*/
  instruction first = A.line_no>B.line_no?B:A;
  instruction second = first==B?A:B;

  /* 1.Read after write */
  if (first.dest == second.source1 ||first.dest == second.source2)
    return 1; //Dependency exists
  
  /* 2.Write after read */
  if (first.source1 == second.dest || first.source2 == second.dest )
    return 1; //Dependency exists
  /* 3.Write after write */
  if (first.dest == second.dest)
    return 1; //Dependency exists

  return 0; // No dependency found

}
