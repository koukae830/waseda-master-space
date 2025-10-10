/**************************************************************************
   Author: Neng-Fa Zhou
   Language: B-Prolog (CLP(FD))
   Problem description:
   The quasi-group problem of size N is to find a lattin square NxN (every row 
   and every column is a permuation of integers 1,2,...,N) such that the 
   multiplication operation has the following properties:

    1. x*x = x
    2. ((y*x)*y)*y = x

**************************************************************************/
go:-
    N=5,
    quasi(N).

quasi(N):-
    new_array(A,[N,N]),
    array_to_list(A,Vars),
    Vars :: 1..N,
    A^rows @= Rows,
    A^columns @= Cols,
    A^diagonal2 @= Diagonal,
    post_all_distinct(Rows),
    post_all_distinct(Cols),
    post_idempotent(Diagonal,1),
    post_qg5(A,1,N),
    labeling_ff(Vars),
    write_rows(Rows).
    
post_all_distinct([]).
post_all_distinct([L|Ls]):-
    all_distinct(L),
    post_all_distinct(Ls).

/* x*x = x */
post_idempotent([],_).
post_idempotent([X|Xs],X):-
    X1 is X+1,
    post_idempotent(Xs,X1).

/* ((y*x)*y)*y = x */
post_qg5(_A,I,N):-I>N,!.
post_qg5(A,I,N):-
    post_qg5(A,I,1,N),
    I1 is I+1,
    post_qg5(A,I1,N).

post_qg5(_A,_I,J,N):-J>N,!.
post_qg5(A,I,J,N):-
    A^[J,I] @= Vyx,
    freeze(Vyx,(A^[Vyx,J]@=Vyxy,freeze(Vyxy,A^[Vyxy,J]@=I))),
    J1 is J+1,
    post_qg5(A,I,J1,N).

write_rows([]).
write_rows([Row|Rows]):-
    writeln(Row),
    write_rows(Rows).
