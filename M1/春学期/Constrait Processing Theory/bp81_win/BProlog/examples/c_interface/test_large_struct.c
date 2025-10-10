#include "bprolog.h"
main(argc,argv)
int             argc;
char           *argv[];
{

  int res;
  char *sol;
  TERM term,x;

  initialize_bprolog(argc,argv);

  term = bp_create_structure("functor",3);  /* functor(X,f,1000) */
  x = bp_build_var();
  bp_unify(x,bp_get_arg(1,term));
  bp_unify(bp_build_atom("f"),bp_get_arg(2,term));
  bp_unify(bp_build_integer(1000),bp_get_arg(3,term));

  bp_mount_query_term(term);

  res = bp_next_solution();
  if (res==BP_TRUE) printf("sol=%s\n",bp_term_2_string(term));
  else printf("STRANGE\n");
}
