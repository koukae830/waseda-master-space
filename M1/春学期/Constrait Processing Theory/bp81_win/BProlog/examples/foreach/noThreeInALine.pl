/*
On an NxN grid locate markers so that no three are in a line and 
no further marker can be placed without violating that restriction. 
Problem posted by Chip Eastham, March 11, 2010
Program by Neng-Fa Zhou, for B-Prolog version 7.4 and up
*/
go:-
    N=8,
    no3_build(N).

no3_build(N):-
    new_array(Board,[N,N]),
    Vars @= [Board[I,J] : I in 1..N, J in 1..N],
    Vars :: 0..1,
    Sum #= sum(Vars),
    Sum #=< 2*N,
    foreach(X1 in 1..N, Y1 in 1..N, [L,SL],  % L and SL are local
            (L @= [Slope : X2 in 1..N, Y2 in 1..N,
                           [Slope],    % Slope is local
                           (X2\==X1,Slope is (Y2-Y1)/(X2-X1))],
            sort(L,SL),
            foreach(Slope in SL,
                 sum([Board[X,Y] : X in 1..N, Y in 1..N, 
                                  (X\==X1,Slope=:=(Y-Y1)/(X-X1))]) #< 3))),
    foreach(X in 1..N, sum([Board[X,Y] : Y in 1..N])#<3),  
    myLabeling([Sum|Vars]),
    outputBoard(Board,Sum,N).

myLabeling([]).
myLabeling([Var|Vars]):-integer(Var),!,
    myLabeling(Vars).
myLabeling([Var|Vars]):-
    fd_min_max(Var,Min,Max),
    indomain_down(Var,Max,Min),
    myLabeling(Vars).

indomain_down(Var,Min,Min):-!,Var=Min.
indomain_down(Var,X,_):-Var=X.
indomain_down(Var,X,Min):-
    fd_prev(Var,X,Next),
    indomain_down(Var,Next,Min).

outputBoard(Board,Sum,N):-
    writeln(marks=Sum),
    foreach(I in 1..N,[Row],
            (Row @= [Board[I,J] : J in 1..N], writeln(Row))).

