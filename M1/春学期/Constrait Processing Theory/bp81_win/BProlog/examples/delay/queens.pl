go:-
    statistics(runtime,[Start|_]),
    queens(8),
    statistics(runtime,[End|_]),
    T is End-Start,
    write('execution time is :'),write(T).
    
queens(N):-
    make_list(N,List),
    range(1,N,D),
    constrain_queens(List),
    label(List,D),
    write(List),nl,
    fail.
queens(_).

constrain_queens([]).
constrain_queens([X|Y]):-
    safe(X,Y,1),
    constrain_queens(Y).

safe(_,[],_).
safe(X,[Y|T],K):-
    noattack(X,Y,K),
    K1 is K+1,
    safe(X,T,K1).

noattack(X,Y,K),var(X),{ins(X),ins(Y)} => true.
noattack(X,Y,K),var(Y),{ins(Y)} => true.
noattack(X,Y,K):-true :
    X =\= Y,
    X+K =\= Y,
    X-K =\= Y.

make_list(0,[]):-!.
make_list(N,[_|Rest]):-
    N1 is N-1,
    make_list(N1,Rest).

range(N,N,[N]) :- !.
range(M,N,[M|Ns]) :-
	M < N,
	M1 is M+1,
	range(M1,N,Ns).

label([],D).
label([V|Vs],D):-
    select(D,Rest,V),
    label(Vs,Rest).
    
select([X|Xs],Xs,X).
select([Y|Ys],[Y|Zs],X) :- select(Ys,Zs,X).

