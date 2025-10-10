go:-
    cputime(Start),
    top,
    cputime(End),        	
    T is End-Start,
    write('cputime='),write(T),nl.

top:-
    D :: {}..{1..1000},
    #D #>= 999,
    clpset_indomain(D),
    fail.
top.

