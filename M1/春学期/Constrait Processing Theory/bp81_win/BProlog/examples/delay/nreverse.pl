go:- 
    mklist(500,L),
    statistics(runtime,[_,_]),
    write(L),nl,
    nrev(L,L1),
    write(L1),nl,
    statistics(runtime,[_,T]),
    write('execution time is '),write(T), write(milliseconds).

mklist(N,L):-
    N=:=0,!,
    L=[].
mklist(N,L):-
    L=[N|L1],
    N1 is N-1,
    mklist(N1,L1).

nrev([],L):-
    L=[].
nrev([X|Xs],L):-
    concat(L1,[X],L),
    nrev(Xs,L1).

concat(X,Y,Z),var(X),{ins(X)} => true.
concat([],L1,L2):-true :
    L2=L1.
concat([X|Xs],L1,L2):-true :
    L2=[X|L3],
    concat(Xs,L1,L3).
