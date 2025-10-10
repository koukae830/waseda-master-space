#include "bprolog.h"
main(argc,argv)
int             argc;
char           *argv[];
{

  int res;
  TERM term;

  initialize_bprolog(argc,argv);

  bp_call_string("load(magic3)");

  bp_mount_query_string("top(X)");
  
  do {
    res = bp_next_solution();
  } while (res==BP_TRUE);

  bp_call_string("load(sendmoney)");

  term = bp_build_structure("top",1);
  bp_mount_query_term(term);
  do {
    res = bp_next_solution();
    if (res==BP_TRUE) bp_write(term);
  } while (res==BP_TRUE);
}
  
