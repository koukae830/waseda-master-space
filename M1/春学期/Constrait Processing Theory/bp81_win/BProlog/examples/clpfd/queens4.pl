%   File   : queens.pl
%   Author : Neng-Fa ZHOU
%   Date   : 2009
%   Purpose: solve N-queens problem with CLP(FD)


top:-
    N=96,
    queens(N).
go:-
    write('N=?'),read(N),
    statistics(runtime,[Start|_]),
    queens(N),
    statistics(runtime,[End|_]),
    T is End-Start,
    write('%execution time ='), write(T), write(' milliseconds'),nl.

queens(N):-
    length(Qs,N),
    Qs in 1..N,
    foreach((I in 1..N-1, J in I+1..N), 
	    [Qi,Qj],
	    (nth(I,Qs,Qi),
	     nth(J,Qs,Qj),
	     Qi #\= Qj,
	     abs(Qi-Qj) #\= abs(I-J))),
     labeling_ff(Qs),
     writeln(Qs).
	     
