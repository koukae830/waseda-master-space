/*
On an NxN grid locate markers so that no three are in a line and
no further marker can be placed without violating that restriction.
Problem posted by Chip Eastham, March 11, 2010
Program by Neng-Fa Zhou, for B-Prolog version 7.4 and up
*/
go:-
    N=7,
    no3_build(N).

no3_build(N):-
    new_array(Board,[N,N]),
    Vars @= [Board[I,J] : I in 1..N, J in 1..N],
    Vars :: 0..1,
    sum(Vars) #>= N,  % lower bound
    foreach(I in 1..N, sum([Board[I,J] : J in 1..N])#<3),
    foreach(J in 1..N, sum([Board[I,J] : I in 1..N])#<3),
    foreach(K in 1-N..N-1,
            sum([Board[I,J] : I in 1..N, J in 1..N, I-J=:=K]) #< 3),
    foreach(K in 2..2*N,
            sum([Board[I,J] : I in 1..N, J in 1..N, I+J=:=K]) #< 3),
    maxof(labeling(Vars),sum(Vars),outputBoard(Board,N)).

outputBoard(Board,N):-
    Marks #= sum([Board[I,J] : I in 1..N, J in 1..N]),
    writeln(marks=Marks),
    foreach(I in 1..N,[Row],
            (Row @= [Board[I,J] : J in 1..N], writeln(Row))). 
