:-table a/3.

go:-
    write('M='),read(M),
    write('N='),read(N),
    a(M,N,A),
    write(ackermana(M,N,A)),nl.

a(0,N,A):-!,A is N+1.
a(M,0,A):-!,M1 is M-1, a(M1,1,A).
a(M,N,A):-
    M1 is M-1,
    N1 is N-1,
    a(M,N1,A1),
    a(M1,A1,A).
