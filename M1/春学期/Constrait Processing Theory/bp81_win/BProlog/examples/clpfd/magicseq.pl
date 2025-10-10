/* 
    Revised by Neng-Fa ZHOU
    taken from "Constraint Satisfaction in LP" by P. Van Hentenryck
    S=(s0,s1,...,sn-1) is a magic sequence if there are si occurrences of i
    for i=0,...,n-1.
*/

go:-
    statistics(runtime,[Start|_]),
    top,
    statistics(runtime,[End|_]),
    T is End-Start,
    write('execution time is '),write(T), write(milliseconds),nl.

top:-
    top(9).

top(N):-
    constrs(N,L),
    labeling(L),
    write(L),
    nl.

constrs(N,L):-
    functor(S,f,N),
    S=..[_|L],
    L in 0..N,
    occurrences(L,0,L),
    sum(L) #= N.

occurrences([],N,L).
occurrences([X|Xs],N,L):-
    count(N,L,'#=',X),
    N1 is N+1,
    occurrences(Xs,N1,L).


    
