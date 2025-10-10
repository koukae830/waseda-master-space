go:-
    qsort([1,3,5,4,5,3,9],L),
    writeln(L).

qsort([],[]).
qsort([H|T],S):-
    L1 @= [X : X in T, X<H],
    L2 @= [X : X in T, X>=H],
    qsort(L1,S1),
    qsort(L2,S2),
    append(S1,[H|S2],S).


    
