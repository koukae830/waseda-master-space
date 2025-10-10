/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw nested squares and diamonds
*********************************************************************/
go:-
    squarediamonds(Os),
    cgWindow(Win,"squareAndDiamonds"),Win^leftMargin #= 20, Win^topMargin #= 50,
    Win^width #> 600, Win^height #> 600,
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgShow(Os).    
go.

squarediamonds(Os):-
    cgSquare(S), S^fill #= 0, S^width #> 500,
    cgPolygon(P), P^fill #= 0, P^n #= 4,
    squareToPolygon(S,P),
    diamondsAndSquares(P,20,Ps),
    Os=[S,P|Ps].

squareToPolygon(S,P):-
    P^point(1) #= S^leftTopPoint,
    P^point(2) #= S^leftBottomPoint,
    P^point(3) #= S^rightBottomPoint,
    P^point(4) #= S^rightTopPoint.

diamondsAndSquares(S,N,Ps):-N=:=0,!,Ps=[].
diamondsAndSquares(S,N,[P|Ps]):-
    cgPolygon(P), P^n #= 4, P^fill #= 0,
    (N mod 2=:=0 -> P^color #= red; true),
    center(P^point(1),S^point(1),S^point(2)),
    center(P^point(2),S^point(2),S^point(3)),
    center(P^point(3),S^point(3),S^point(4)),
    center(P^point(4),S^point(4),S^point(1)),
    N1 is N-1,
    diamondsAndSquares(P,N1,Ps).

center(CP,P1,P2):-
    CP^x #= (P1^x+P2^x)//2,
    CP^y #= (P1^y+P2^y)//2.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

    


    
