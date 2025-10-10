/*  by Neng-Fa Zhou, 2004 
    In the following state of the Minsweeper game,
    find all the mine and safe squares. 

    -----------------
    |   |   |   |   |
    -----------------
    | 2 |   | 1 |   |
    -----------------
    | 1 |   |   |   |
    -----------------
    | 1 |   | 1 |   |
    -----------------

    We use a variable for each of the uncovered squares, 
    which has the domain [0,1] (0 means safe and 1 means
    mine).
    
    -----------------
    | X1| X2| X3| X4|
    -----------------
    | 2 | X5| 1 | X6|
    -----------------
    | 1 | X7| X8| X9|
    -----------------
    | 1 |X10| 1 |X11|
    -----------------

    The constraints are as follows:

    X1+X2+X5+X7 = 2
    X5+X7+X10 = 1
    X7+X10 = 1
    X2+X3+X4+X5+X6+X7+X8+X9 = 1
    X7+X8+X9+X10+X11 = 1
    
    A square is undecided if the variable can be assigned 
    either 0 or 1, a mine if it can be assigned only 1, 
    and safe if it can be assigned only 0.
*/

go:-
    Vars = [X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11],
    Vars :: [0,1],
    X1+X2+X5+X7 #= 2,
    X5+X7+X10 #= 1,
    X7+X10 #= 1,
    X2+X3+X4+X5+X6+X7+X8+X9 #= 1,
    X7+X8+X9+X10+X11 #= 1,
    testSquares(1,Vars,[]).

testSquares(I,[],_).
testSquares(I,[X|Xs],Ys):-
    append(Xs,Ys,Vs),
    testSquare(I,X,Vs),
    I1 is I+1,
    testSquares(I1,Xs,[X|Ys]).
    
testSquare(I,V,Vs):-
    (not(not(safeSquare(I,V,Vs)))->
     (not(not(mineSquare(I,V,Vs)))->
      format("X~w is undecided~n",[I]);
      format("X~w is safe~n",[I]));
     format("X~w is a mine~n",[I])).

safeSquare(I,V,Vs):-
    V=0,
    labeling(Vs).


mineSquare(I,V,Vs):-
    V=1,
    labeling(Vs).




