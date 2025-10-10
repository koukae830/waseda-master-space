:-table fib/2.

go :- 
    write('Enter N : '), read(N), nl, 
    cputime(Start),
    fib(N, Fib), 
    cputime(End),
    write('Fib of '), write(N), write(' is '), write(Fib),nl,
    T is End-Start,
    write('%execution time ='), write(T), write(' milliseconds'),nl.

fib(0, 1):-!.
fib(1, 1):-!.
fib(N,F):-N>1,N1 is N-1, N2 is N-2,fib(N1,F1),fib(N2,F2),F is F1+F2.
