/* Verify the DeMorgan's law over the domain {1..7} */
go:-
    cputime(Start),
    top,
    cputime(End),        	
    T is End-Start,
    write('cputime='),write(T),nl.

top:-
    Univ={1,2,3,4,5,6,7},
    [X,Y] :: {}..Univ,
    \(X/\Y) #= \X \/ \Y,
%    Univ \ (X/\Y) #= (Univ \X) \/ (Univ \Y),
    \(X\/Y) #= \X /\ \Y,
%    Univ \ (X\/Y) #= (Univ \X) /\ (Univ \Y),
    indomain(X),indomain(Y),
    fail.
top.

