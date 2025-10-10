%   S=(x0,x1,...,x(n-1)) is a magic sequence if there are xi occurrences of i
%   for i=0,...,n-1.
%   by Neng-Fa ZHOU, Feb. 2010

go:-
    statistics(runtime,[Start|_]),
    magic_seq(9),
    statistics(runtime,[End|_]),
    T is End-Start,
    write('execution time is '),write(T), write(milliseconds),nl.

magic_seq(N):-
    length(S,N),
    S :: 0..N-1,
    foreach(I in 0..N-1,
	    sum([(S[J]#=I) : J in 1..N])#=S[I+1]),
    labeling(S),
    writeln(S).

