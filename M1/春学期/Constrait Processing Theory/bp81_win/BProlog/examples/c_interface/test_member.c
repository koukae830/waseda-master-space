#include "bprolog.h"

main(argc,argv)
int             argc;
char           *argv[];
{

  TERM query;
  TERM list0,list;
  int res;
  
  initialize_bprolog(argc,argv);
  /* build a list [1,2,3] */
  list = list0 = bp_build_list();
  bp_unify(bp_get_car(list),bp_build_integer(1));
  bp_unify(bp_get_cdr(list),bp_build_list());
  list = bp_get_cdr(list);
  bp_unify(bp_get_car(list),bp_build_integer(2));
  bp_unify(bp_get_cdr(list),bp_build_list());
  list = bp_get_cdr(list);
  bp_unify(bp_get_car(list),bp_build_integer(3));
  bp_unify(bp_get_cdr(list),bp_build_nil());

  /* build the call member(X,list) */
  query = bp_build_structure("member",2);
  bp_unify(bp_get_arg(2,query),list0);

  /* invoke member/2 */
  bp_mount_query_term(query);
  res = bp_next_solution();
  while (res==BP_TRUE){
    bp_write(query); printf("\n");
    res = bp_next_solution();
  }
}
