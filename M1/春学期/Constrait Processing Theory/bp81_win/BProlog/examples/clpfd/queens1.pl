%   File   : queens.pl
%   Author : Neng-Fa ZHOU
%   Date   : 1992
%   Purpose: solve N-queens problem with CLP(FD)


top:-
    N=96,
    make_list(N,List),
    List in 1..N,
    constrain_queens(List),
    labeling_ffc(List),
    write(List).

go:-
    write('N=?'),read(N),queens(N).

queens(N):-
    statistics(runtime,[Start|_]),
    top(N),
    statistics(runtime,[End|_]),
    T is End-Start,
    write('%execution time ='), write(T), write(' milliseconds'),nl.

top(N):-
    length(List,N),
    List in 1..N,
    constrain_queens(List),
    labeling_ffc(List),
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

noattack(X,Y,K):-
    X #\= Y,
    X+K #\= Y,
    X-K #\= Y.

