#include "bprolog.h"

main(argc,argv)
int             argc;
char           *argv[];
{

  int sol;
  TERM query;
  int res;
  
  initialize_bprolog(argc,argv);

  res = bp_call_string("foo(2)");
  switch (res){
  case BP_ERROR: printf("error\n"); break;
  case BP_TRUE:printf("true\n"); break;
  case BP_FALSE:printf("false\n"); break;
  }
}
