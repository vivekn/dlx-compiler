#include<stdio.h>
#include<stdlib.h>
#define MAXNODES 6

/* Structure to represent a node on the graph using adjacency lists. */

struct node {
  int id; /* The id of a node is stored as (index in nodes array) + 1 */
  int visited; /* Stores a 0 or 1 depending on whether the node has been visited */
  int nodes_out[MAXNODES]; /* nodes out of the graph with a similar indexing scheme */
  int nodes_in[MAXNODES]; /* nodes in to the graph with a similar indexing scheme */
};


typedef struct node node;
node nodes[MAXNODES]; /* The graph as an array of nodes */

/* 'l' contains the result of the sort while 'ctr' is a counter used to push elements to l */
int l[MAXNODES],ctr;


void init_tsort() {
/* Perform some initializations */
  ctr = 0;
}

void visit(node a) {
/* Recursive function that performs a depth first search */
  if (a.visited == 0) {

    nodes[a.id-1].visited = 1;
    int i;
    for(i = 0;i<MAXNODES;i++) {
      if(a.nodes_out[i])
	visit(nodes[(a.nodes_out[i])-1]);
    }

    l[ctr++] = a.id;
  }
}

void rotate_array(int *array,int size) {
  /* rotates an array by 1 position */
  int *temp = calloc(size,sizeof(int));
  int i;
  for(i = 1;i<size;i++)
    temp[i-1] = array[i];
  temp[size-1] = array[0];
  for(i = 0;i<size;i++) 
    array[i] = temp[i];
}


void reset_nodes() {
/* Resets the visited parameter of all nodes back to zero */
  int i =0;
  for(i = 0;i<MAXNODES;i++) 
    nodes[i].visited = 0;
}

void sort() {
/* The actual sorting function  */
  int i = 0,ctr2=0,j;
  node S[MAXNODES]; /* Stores the nodes with no incoming edges */
  for(i = 0; i < MAXNODES;i++){
    int flag = 1;
    for(j = 0 ; j < MAXNODES;j++){
      if(nodes[i].nodes_in[j]) {
	flag = 0;
	break;
      }
    }
    if (flag) 
      S[ctr2++] = nodes[i];
    }


  /* Visit each node in S */
  for(i =0; i<ctr2;i++) 
    visit(S[i]);
    
  /* Print the results of the sort */
  for(i=0;i<MAXNODES;i++) 
    printf("%d ",l[i]);

}

  

void unit_test() {
/* A simple unit test. */
  init_tsort();
  node temp = {1,0,{},{2,5}};
  nodes[0] = temp;
  
  node temp1 = {2,0,{1},{}};
  nodes[1] = temp1;

  node temp2 = {3,0,{},{4,5}};
  nodes[2] = temp2;

  node temp3 = {4,0,{3},{6}};
  nodes[3] = temp3;

  node temp4 = {5,0,{1,3},{}};
  nodes[4] = temp4;

  node temp5 = {6,0,{4},{}};
  nodes[5] = temp5;
  sort();
}

void main() {
  unit_test();
}
