/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    n-queen puzzle
*********************************************************************/
go:-
    cgWindow(Win,"queens"),Win^topMargin #= 40,
    Win^leftMargin #= 10,
    Win^width #>= 610,  Win^height #>= 610,
    handleWindowClosing(Win),
    queens(Win).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

queens(Win):-
    cgLabel(Lab,"N=?"),
    cgTextField(Tf,"50",4),
    cgLeft(Lab,Tf),
    Tf^bottomY+10 #= Y0, % draw board below Y0
    cgSame([Lab,Tf],window,Win),
    cgShow([Lab,Tf]),
    handleInputN(Tf,Win,Y0),
    searchAndDrawQueens(Tf,Win,Y0).

handleInputN(Tf,Win,Y0),
    {actionPerformed(Tf)}
    =>
    searchAndDrawQueens(Tf,Win,Y0).

searchAndDrawQueens(Tf,Win,Y0):-
    cgCleanDrawing(Win),
    cgGetText(Tf,NString),
    number_codes(N,NString),
    GridSize is 600//N,
    global_set(grid_size,GridSize),
    solveAndCreateQueens(N,Comps,Y0),
    cgSame(Comps,window,Win),
    cgShow(Comps).

solveAndCreateQueens(N,Comps,Y0):-
    queens(N,Qs),!,
    writeln(Qs),
    drawQueens(N,Qs,Comps,Y0).

queens(N,List):-
    length(List,N),
    List in 1..N,
    constrain_queens(List),
    labeling([ff,inout],List).

constrain_queens([]).
constrain_queens([X|Y]):-
    safe(X,Y,1),
    constrain_queens(Y).

safe(_,[],_).
safe(X,[Y|T],K):-
    noattack(X,Y,K),
    K1 is K+1,
    safe(X,T,K1).

noattack(X,Y,K):-
    X #\= Y,
    X+K #\= Y,
    X-K #\= Y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
drawQueens(N,Qs,Comps,Y0):-
    global_get(grid_size,GS),
    drawQueens(0,Qs,Comps,Comps1,Y0,GS),
    drawBoard(N,Comps1,[],Y0,GS).

drawBoard(N,Comps,CompsR,Y0,GS):-
    drawHorizontalLines(0,N,Comps,Comps1,Y0,GS),
    drawVerticalLines(0,N,Comps1,CompsR,Y0,GS).

drawHorizontalLines(I,N,Comps,CompsR,Y0,GS):-I>N,!,Comps=CompsR.
drawHorizontalLines(I,N,Comps,CompsR,Y0,GS):-
    cgLine(Line),
    Line^x1 #= 10, Line^y1 #= GS*I+Y0,
    Line^x2 #= GS*N+10, Line^y2 #= Line^y1,
    Comps=[Line|Comps1],
    I1 is I+1,
    drawHorizontalLines(I1,N,Comps1,CompsR,Y0,GS).

drawVerticalLines(I,N,Comps,CompsR,Y0,GS):-I>N,!,Comps=CompsR.
drawVerticalLines(I,N,Comps,CompsR,Y0,GS):-
    cgLine(Line),
    Line^x1 #= GS*I+10, Line^y1 #= Y0,
    Line^x2 #= Line^x1, Line^y2 #= N*GS+Y0,
    Comps=[Line|Comps1],
    I1 is I+1,
    drawVerticalLines(I1,N,Comps1,CompsR,Y0,GS).
    
drawQueens(_I,[],Comps,CompsR,Y0,GS):-Comps=CompsR.
drawQueens(I,[J|Js],Comps,CompsR,Y0,GS):-
    cgSquare(S),
    S^x #= I*GS+10,
    S^y #= (J-1)*GS+Y0,
    S^width #= GS,
    S^height #= GS,
    S^color #= red,
    Comps=[S|Comps1],
    I1 is I+1,
    drawQueens(I1,Js,Comps1,CompsR,Y0,GS).
