% by Neng-Fa Zhou, Jan. 2012

/* Boolean version */

queens(N):-
    new_array(Qs,[N,N]),
    Vars @= [Qs[I,J] : I in 1..N, J in 1..N],
    Vars :: 0..1,
    foreach(I in 1..N,
            sum([Qs[I,J] : J in 1..N]) $= 1),
    foreach(J in 1..N,
            sum([Qs[I,J] : I in 1..N]) $= 1),
    foreach(K in 1-N..N-1,
            sum([Qs[I,J] : I in 1..N, J in 1..N, I-J=:=K]) $=< 1),
    foreach(K in 2..2*N,
            sum([Qs[I,J] : I in 1..N, J in 1..N, I+J=:=K]) $=< 1),
    sat_solve(Vars),
    foreach(I in 1..N,[Row],
            (Row @= [Qs[I,J] : J in 1..N], writeln(Row))).

go:-
    queens(100).

