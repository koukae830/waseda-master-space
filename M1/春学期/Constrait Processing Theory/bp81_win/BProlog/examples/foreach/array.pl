go:-
    go(8).

go(N):-
    new_array(A,[N,N]),
    foreach(I in 1..N,J in 1..N,A[I,J] is (I-1)*N+J),
    foreach(I in 1..N, 
	    (foreach(J in 1..N,[E],(E @= A[I,J], format("~4d ",[E]))),nl)),
    array_min_max(A,Min,Max),
    writeln(min=Min),
    writeln(max=Max).

array_min_max(A,Min,Max):-
    A11 is A[1,1],
    foreach(I in 1..A^length, J in 1..A[1]^length, [Aij], [ac(Min,A11),ac(Max,A11)],
	    (Aij is A[I,J],
	     (Aij<Min^0->Min^1=Aij;Min^1=Min^0),
	     (Aij>Max^0->Max^1=Aij;Max^1=Max^0))).

