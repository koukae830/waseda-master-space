/********************************************************************
  CGLIB: Constraint-based Graphical Programming in B-Prolog
  %
  draw a chessboard of squares
*********************************************************************/
go:-
    squares.
go.

squares:-
    cgWindow(Win,"squares"),Win^topMargin #= 30, Win^leftMargin #= 20,
    handleWindowClosing(Win),
    squares(Os,Win),
    cgSame(Os,window,Win),
    cgShow(Os).

squares(Spirals,Win):-
    N = 5,
    length(Squares,N),
    createSquares(N,Squares),
    cgGrid(Squares),
    listlist2list(Squares,SquaresList),
    cgSame(SquaresList,window,Win),  
    cgPack(SquaresList), % pack the bounding squares first
    spirals(Squares,2,8,Spirals),!.

listlist2list([],List):-List=[].
listlist2list([X|Xs],List):-
    listlist2list(Xs,List1),
    append(X,List1,List).
    
createSquares(N,[]).
createSquares(N,[X|Xs]):-
    length(X,N),
    cgSquare(X),
    cgSame(X,width,Width),Width #= 50,
    cgSame(X,fill,0),
    createSquares(N,Xs).

spirals([],I,J,Spirals):-Spirals=[].
spirals([List|Lists],I,J,Spirals):-
    spirals1(List,I,J,Spirals,SpiralsR),
    spirals(Lists,J,I,SpiralsR).
    
spirals1([],I,J,Spirals,SpiralsR):-Spirals=SpiralsR.
spirals1([S|List],I,J,Spirals,SpiralsR):-
    spiral(10,I,J,S,Spirals,Spirals1),
    spirals1(List,J,I,Spirals1,SpiralsR).

spiral(N,I,J,R,Spirals,SpiralsR):-
    Spirals=[P|Spirals1],
    rectToPoly(R,P),
    spiral1(N,I,J,P,Spirals1,SpiralsR).

spiral1(N,I,J,P,Spirals,SpiralsR):-N=:=0,!,Spirals=SpiralsR.
spiral1(N,I,J,P,Spirals,SpiralsR):-
    Spirals=[NewP|Spirals1],
    rotatePoly(P,I,J,NewP),
    N1 is N-1,
    spiral1(N1,I,J,NewP,Spirals1,SpiralsR).
    
rectToPoly(S,P):-
    cgPolygon(P), P^n #= 4, P^fill #= 0,
    P^point(1) #= S^leftTopPoint,
    P^point(2) #= S^leftBottomPoint,
    P^point(3) #= S^rightBottomPoint,
    P^point(4) #= S^rightTopPoint.

rotatePoly(P,I,J,NewP):-
    cgPolygon(NewP),
    NewP^n #= 4,
    NewP^fill #=0,
    NewP^x(1) #= I*P^x(1)//10 + J*P^x(2)//10,
    NewP^y(1) #= I*P^y(1)//10 + J*P^y(2)//10,
    NewP^x(2) #= I*P^x(2)//10 + J*P^x(3)//10,
    NewP^y(2) #= I*P^y(2)//10 + J*P^y(3)//10,
    NewP^x(3) #= I*P^x(3)//10 + J*P^x(4)//10,
    NewP^y(3) #= I*P^y(3)//10 + J*P^y(4)//10,
    NewP^x(4) #= I*P^x(4)//10 + J*P^x(1)//10,
    NewP^y(4) #= I*P^y(4)//10 + J*P^y(1)//10.
    
handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).


