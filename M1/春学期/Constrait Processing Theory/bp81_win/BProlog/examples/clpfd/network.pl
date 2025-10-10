/*  Given a network G=(N,A) where N is a set of nodes and A is a set of arcs. 
    Each arc (i,j) in A has a capacity Cij which limits the amount of flow 
    that can be sent throw it. Find the maximum flow that can be sent between
    a single source and a single sink.

    N={1,2,3,4,5,6,7,8}
    Capacity matrix:
       1   2   3   4   5   6   7   8
    ================================
    1      3   2   3
    2                          5
    3      1               1
    4          2       2
    5                              5
    6      4           2           1
    7                      2       3
    8
    by Neng-Fa Zhou, July 2008
*/
go:-
    Vars=[X12,X13,X14,
	   X27,
	   X32,X36,
	   X43,X45,
	   X58,
          X62,X65,X68,
          X76,X78],
    X12 :: 0..3,
    X13 :: 0..2,
    X14 :: 0..3,
    X27 :: 0..5,
    X32 :: 0..1,
    X36 :: 0..1,
    X43 :: 0..2,
    X45 :: 0..2,
    X58 :: 0..5,
    X62 :: 0..4,
    X65 :: 0..5,
    X68 :: 0..1,
    X76 :: 0..2,
    X78 :: 0..3,
    X12+X32+X62-X27 #= 0,
    X13+X43-X32-X36 #= 0,
    X14-X43-X45 #= 0,
    X45+X65-X58 #= 0,
    X36+X76-X62-X65-X68 #= 0,
    X27-X76-X78 #= 0,
    maxof(labeling(Vars),X58+X68+X78),
    Max is X58+X68+X78,
    writeln(sol(Vars,Max)).


    
    
    
    
    
    


       
