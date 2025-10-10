/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw Sierpinski's triangles
*********************************************************************/
go:-
   sierpinski.
go.

sierpinski:-
   cgWindow(Win,"sierpinski"), Win^topMargin #= 30, Win^leftMargin #= 20, Win^width #> 600,Win^height #>600,
   handleWindowClosing(Win),
   sierpinski(Os,Win),
   cgSame(Os,window,Win),
   cgShow(Os).

sierpinski([T|Ts],Win):-
   cgSquare(S), S^fill #= 0, S^width #> 500,
   S^window #=Win, cgPack(S),
   cgTriangle(T), T^fill #= 0,
   cutSquare(S,T),
   divideTriangle(T,5,Ts,[]).

cutSquare(S,T):-
   T^point1 #= S^leftTopPoint,
   T^point2 #= S^leftBottomPoint,
   T^point3 #= S^rightBottomPoint.

divideTriangle(T,N,Ts,TsR):-N=:=0,!,Ts=TsR.
divideTriangle(T,N,Ts,TsR):-
   Ts=[T1,T2,T3|Ts1],
   P1 #= T^point1, P2 #= T^point2, P3 #= T^point3,
   %%
   cgTriangle(T1),T1^fill #= 0,
   T1^point1 #= P1, center(T1^point2,P1,P2), center(T1^point3,P1,P3),
   %%
   cgTriangle(T2), T2^fill #= 0,
   center(T2^point1,P1,P2), T2^point2 #= P2, center(T2^point3,P2,P3),
   %%
   cgTriangle(T3), T3^fill #= 0,
   center(T3^point1,P1,P3), center(T3^point2,P2,P3), T3^point3 #= P3,
   %%
   N1 is N-1,
   divideTriangle(T1,N1,Ts1,Ts2),
   divideTriangle(T2,N1,Ts2,Ts3),
   divideTriangle(T3,N1,Ts3,TsR).

center(CP,P1,P2):-
   CP^x #= (P1^x+P2^x)//2,
   CP^y #= (P1^y+P2^y)//2.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).


