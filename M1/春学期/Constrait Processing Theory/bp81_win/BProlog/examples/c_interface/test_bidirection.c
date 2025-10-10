#include "bprolog.h"

test_interface_c_pred(){
  TERM origX = bp_get_call_arg(1,2);
  TERM X = bp_get_call_arg(2,2);
  TERM call;
  
  call = bp_build_structure("test_interface_prolog_pred",2);
  bp_unify(bp_get_arg(1,call),bp_build_integer(bp_get_integer(origX)+1));
  bp_unify(bp_get_arg(2,call),X);
  bp_write(call);
  bp_call_term(call);
}

main(argc,argv)
int             argc;
char           *argv[];
{

  int sol;
  TERM query;
  int res;

  initialize_bprolog(argc,argv);

  insert_cpred("test_interface_c_pred",2,test_interface_c_pred);
  
  bp_call_string("[test_c_interface]");
  
  query = bp_build_structure("test_interface_prolog_pred",2); /* "test_interface_prolog_pred(0,X)" */
  bp_unify(bp_build_integer(0),bp_get_arg(1,query));

  bp_write(query);
  bp_call_term(query);
  bp_call_string("statistics");
}


