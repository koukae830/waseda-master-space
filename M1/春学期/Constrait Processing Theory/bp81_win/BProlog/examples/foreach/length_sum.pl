go:-
    length_sum([1,2,3],N,S),
    writeln((N,S)).

length_sum(L,N,S):-
    foreach(X in L, [ac(N,0),ac(S,0)], (N^1 is N^0+1, S^1 is S^0+X)).
