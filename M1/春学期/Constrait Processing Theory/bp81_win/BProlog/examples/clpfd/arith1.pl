/* place a different digit in 1..9 in each X to make the equation hold 

    XX/XXX + XX/XX = 7

*/
go:-
    Vars = [A,B,C,D,E,F,G,H,I],
    Vars :: 1..9,
    AB #= A*10+B,
    CDE #= C*100+D*10+E,
    FG #= F*10+G,
    HI #= H*10+I,
    
    AB*HI + FG*CDE #= 7*CDE*HI,

    all_different(Vars),
    labeling(Vars),
    write(Vars),nl,fail.
go.


