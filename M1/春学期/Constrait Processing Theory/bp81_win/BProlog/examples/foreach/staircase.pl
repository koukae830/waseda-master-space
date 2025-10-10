/* Draw a staircase of a given steps. Example query:

?-go(4).
            +---+
            |   |
        +---+---+
        |   |   |
    +---+---+---+
    |   |   |   |
+---+---+---+---+
|   |   |   |   |
+---+---+---+---+   
*/
go:-
    go(4).

go(N):-
    foreach(I in 1..N,
	    (foreach(J in 1..N-I,  write('    ')),
	     foreach(J in 1..I,  write('+---')),
	     writeln('+'),
	     foreach(J in 1..N-I,  write('    ')),
	     foreach(J in 1..I,  write('|   ')),
	     writeln('|'))),
    foreach(I in 1..N, write('+---')), writeln('+').
