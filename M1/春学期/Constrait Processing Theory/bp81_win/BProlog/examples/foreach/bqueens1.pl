/* Boolean version */
go:-
    bool_queens(16).

bool_queens(N):-
    new_array(Qs,[N,N]),
    Vars @= [Qs[I,J] : I in 1..N, J in 1..N],
    Vars :: 0..1,
    foreach(I in 1..N,
            sum([Qs[I,J] : J in 1..N]) #= 1),
    foreach(J in 1..N,
            sum([Qs[I,J] : I in 1..N]) #= 1),
    foreach(K in 1-N..N-1,
            sum([Qs[I,J] : I in 1..N, [J], (J is I-K,J>=1,J=<N)]) #=< 1),
    foreach(K in 2..2*N,
            sum([Qs[I,J] : I in 1..N, [J], (J is K-I,J>=1,J=<N)]) #=< 1),
    labeling(Vars),
    foreach(I in 1..N,[Row],
            (Row @= [Qs[I,J] : J in 1..N], writeln(Row))).
