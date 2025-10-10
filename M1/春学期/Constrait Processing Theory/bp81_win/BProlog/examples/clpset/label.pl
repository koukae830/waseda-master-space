/* Verify the DeMorgan's law over the domain {1..7} */
go:-
    cputime(Start),
    top,
    cputime(End),        	
    T is End-Start,
    write('cputime='),write(T),nl.

top:-
    X :: {}..{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15},
    indomain(X),
    fail.
top.
