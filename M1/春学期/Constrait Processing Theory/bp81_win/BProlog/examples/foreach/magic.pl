/* Solve the magic square puzzle of size N*N */

go:-
    go(7).

go(N):-
    new_array(Board,[N,N]),
    NN is N*N,
    Vars @= [Board[I,J] : I in 1..N, J in 1..N],
    Vars :: 1..NN,
    Sum is NN*(NN+1)//(2*N),
    foreach(I in 1..N,sum([Board[I,J] : J in 1..N]) #= Sum),
    foreach(J in 1..N,sum([Board[I,J] : I in 1..N]) #= Sum),
    sum([Board[I,I] : I in 1..N]) #= Sum,
    sum([Board[I,N-I+1] : I in 1..N]) #= Sum,
    all_different(Vars),
    labeling([ffc],Vars),
    foreach(I in 1..N, 
	    (foreach(J in 1..N, [Bij], (Bij @= Board[I,J], format("~4d ",[Bij]))),nl)).



