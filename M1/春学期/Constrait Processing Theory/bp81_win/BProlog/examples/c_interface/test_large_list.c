#include "bprolog.h"
main(argc,argv)
int             argc;
char           *argv[];
{

  char *sol;
  TERM term;
  
  initialize_bprolog(argc,argv);

  term = bp_build_structure("length",2);
  bp_unify(bp_build_integer(10),bp_get_arg(2,term));
  
  bp_mount_query_term(term);

  sol = bp_next_solution();
  bp_write(term); printf("\n");
  printf("%s\n",bp_term_2_string(term));
}
