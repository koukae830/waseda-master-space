%   File   : queens.pl
%   Author : Neng-Fa ZHOU
%   Date   : 1992
%   Purpose: solve N-queens problem with CLP(FD)


top:-
    N=96,
    make_list(N,List),
    List in 1..N,
    constrain_queens(List),
    stable_labeling_ff(List),
    write(List).

go:-
    write('N=?'),read(N),queens(N).

queens(N):-
    statistics(runtime,[Start|_]),
    once(N),
    statistics(runtime,[End|_]),
    T is End-Start,
    write('%execution time ='), write(T), write(' milliseconds'),nl.

once(N):-
    make_list(N,List),
    List in 1..N,
    constrain_queens(List),
    stable_labeling_ff(List),
    write(List),nl.

constrain_queens([]).
constrain_queens([X|Y]):-
    safe(X,Y,1),
    constrain_queens(Y).

safe(_,[],_).
safe(X,[Y|T],K):-
    noattack(X,Y,K),
    K1 is K+1,
    safe(X,T,K1).
/*
noattack(X,Y,K):-
    X #\= Y,
    X+K #\= Y,
    X-K #\= Y.
*/
delay noattack(X,Y,K):-dvar(X),dvar(Y) : true.
noattack(X,Y,K):-dvar(X) : 
    X1 is Y+K, X2 is Y-K, 
    domain_set_false(X,Y),
    domain_set_false(X,X1),
    domain_set_false(X,X2).
noattack(X,Y,K):-dvar(Y) : 
    Y1 is X+K,Y2 is X-K,
    domain_set_false(Y,X),
    domain_set_false(Y,Y1),
    domain_set_false(Y,Y2).
noattack(X,Y,K):-true :
    X=\=Y,
    X+K=\=Y,
    X-K=\=Y.

make_list(0,[]):-!.
make_list(N,[_|Rest]):-
    N1 is N-1,
    make_list(N1,Rest).
