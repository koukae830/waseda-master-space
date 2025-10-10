#include "bprolog.h"
main(argc,argv)
int             argc;
char           *argv[];
{

  int sol;
  TERM query;

  initialize_bprolog(argc,argv);

  bp_call_string("load(queens_8)");
  
  query = bp_build_structure("queens",2);
  bp_unify(bp_build_integer(8),bp_get_arg(1,query));

  bp_mount_query_term(query);

  do {
    sol = bp_next_solution();
    if (sol==BP_TRUE){bp_write(query); printf("\n");}
  } while (sol == BP_TRUE);
}





