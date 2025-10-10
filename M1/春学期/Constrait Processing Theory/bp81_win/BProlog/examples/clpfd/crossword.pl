go:-
    crossword([X1,X2,X3,X4,X5,X6,X7]),
    format("~s~n",[X1,X2,32]),
    format("~s~n",[X3,X4,X5]),
    format("~s~n",[32,X6,X7]).

 crossword(Vars):-
    Vars=[X1,X2,X3,X4,X5,X6,X7], 
    Words2=[(0'I,0'N),
            (0'I,0'F),
            (0'A,0'S),
            (0'G,0'O),
            (0'T,0'O)],
    Words3=[(0'F,0'U,0'N),
            (0'T,0'A,0'D),
            (0'N,0'A,0'G),
            (0'S,0'A,0'G)],
    [(X1,X2),(X1,X3),(X5,X7),(X6,X7)] in Words2,
    [(X3,X4,X5),(X2,X4,X6)] in Words3,
    labeling(Vars).
