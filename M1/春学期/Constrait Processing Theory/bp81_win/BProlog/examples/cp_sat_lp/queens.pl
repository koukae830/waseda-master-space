% by Neng-Fa Zhou, Jan. 2012

queens(N):-
    length(Qs,N),
    Qs :: 1..N,
    foreach(I in 1..N-1, J in I+1..N,
           (Qs[I] $\= Qs[J],
            Qs[I]-Qs[J] $\= J-I,
            Qs[J]-Qs[I] $\= J-I)),
    cp_solve(Qs),
    writeln(Qs).
         
go:-
    queens(100).

    
         
         
