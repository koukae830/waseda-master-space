#include "bprolog.h"
#include "sapi.h"
main(argc,argv)
int             argc;
char           *argv[];
{

  int sol,arity;
  SP_pred_ref load;
  SP_term_ref a0,a1,a2,a3,a4,a5,query,eight;
  unsigned long atom,functor_atom;
  double d;
  char *str;
  
  initialize_bprolog(argc,argv);
  
  a1 = SP_new_term_ref();
  SP_put_string(a1,"queens_8");
  load = SP_predicate("load",1);

  SP_query(load,a1);

  query = SP_new_term_ref();
  SP_put_functor(query,SP_atom_from_string("queens"),2);

  eight = SP_new_term_ref();
  SP_put_integer(eight,8);

  a0 = SP_new_term_ref();
  SP_put_float(a0,4.59999);

  a1 = SP_new_term_ref();
  SP_put_atom(a1,SP_atom_from_string("2.3"));

  a2 = SP_new_term_ref();
  SP_put_list_n_chars(a2,SP_new_term_ref(),7,"2.345");

  a3 = SP_new_term_ref();
  SP_put_number_chars(a3,"2.345");

  a4 = SP_new_term_ref();
  SP_put_list(a4);


  a5 = SP_new_term_ref();
  SP_cons_functor(a5,SP_atom_from_string("f"),4,a1,a2,a3,a4);

  bp_write(a5);
  printf("type = %d\n",SP_term_type(a5));
  switch (SP_term_type(a5)){
  case SP_TYPE_VARIABLE: printf("variable\n");break;
  case SP_TYPE_INTEGER: printf("integer\n");break;
  case SP_TYPE_FLOAT:printf("float\n");break;
  case SP_TYPE_ATOM:printf("atom\n");break;
  case SP_TYPE_COMPOUND:printf("compound\n");break;
  }

  SP_get_float(a3,&d);
  printf("get_float %lf\n",d);

  SP_get_string(a1,&str);
  printf("get_string %s\n",str);

  SP_get_list_chars(a2,&str);
  printf("get_list_chars %s\n",str);

  SP_get_number_chars(a0,&str);
  bp_write(a0);
  printf("get_number_chars %s\n",str);

  SP_get_functor(a5,&functor_atom,&arity);
  printf("get_functor %s/%d\n",SP_string_from_atom(functor_atom),arity);

  bp_call_string("statistics");
}





