go:-
    queens(100).

queens(N):-
    length(Qs,N),
    Qs :: 1..N,
    foreach(I in 1..N-1, J in I+1..N,[Qi,Qj],
           (nth(I,Qs,Qi),
            nth(J,Qs,Qj),
            Qi #\= Qj,
            abs(Qi-Qj) #\= J-I)),
    labeling([ff],Qs),
    writeln(Qs).
