/********************************************************************
  CGLIB: Constraint-based Graphical Programming in B-Prolog
  %
  draw a rotating triangle
*********************************************************************/
go:-
    triangles.
go.

triangles:-
    triangles(Os),
    cgWindow(Win,"triangles"), Win^topMargin #= 30, Win^leftMargin #= 10,
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgShow(Os).

triangles([T|Ts]):-
 cgSquare(S),S^fill #= 0, S^width #> 300,
 cgTriangle(T),
 T^fill #=0,
 constrainT(S,T),
 newT(T,50,Ts).

 constrainT(S,T):-
    T^x1 #= S^centerX,
    T^y1 #= S^y,
    T^x2 #= S^x,
    T^y2 #= S^bottomY,
    T^x3 #= S^rightX,
    T^y3 #= T^y2.

 newT(T,N,Ts):-N=:=0,!,Ts=[].
 newT(T,N,[Th|Tt]):-
    cgTriangle(Th),
    Th^fill #=0,
    Th^x1 #= 95*T^x1//100 + 5*T^x2//100,
    Th^y1 #= 95*T^y1//100 + 5*T^y2//100,
    Th^x2 #= 95*T^x2//100 + 5*T^x3//100,
    Th^y2 #= 95*T^y2//100 + 5*T^y3//100,
    Th^x3 #= 95*T^x3//100 + 5*T^x1//100,
    Th^y3 #= 95*T^y3//100 + 5*T^y1//100,
    N1 is N-1,
    newT(Th, N1,Tt).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).



