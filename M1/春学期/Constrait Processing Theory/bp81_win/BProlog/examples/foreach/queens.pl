go:-
    queens(100).

queens(N):-
    length(Qs,N),
    Qs :: 1..N,
    foreach(I in 1..N-1, J in I+1..N,
           (Qs[I] #\= Qs[J],
            abs(Qs[I]-Qs[J]) #\= J-I)),
    labeling([ff],Qs),
    writeln(Qs).
         
    
         
         
