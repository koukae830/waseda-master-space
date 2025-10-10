/********************************************************************
    CGLIB: Constraint-based Graphical Programming in B-Prolog
    %
    Recursive graphics
    by Liya
*********************************************************************/


go:-
    cgWindow(Win,"Pythagoras"), Win^width #> 650, Win^height #> 600,
    handleWindowClosing(Win),
    pythagoras(Ps),
    cgSame(Ps,window,Win),
    cgShow(Ps).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

pythagoras([P|Ps]):-
  cgSquare(S),S^fill #=0,
  S^x #=300,
  S^y #=400,
  S^width #=100,
  rectToPolygon(S,P),
  pythagoras(P,8,Ps,[]).

rectToPolygon(S,P):-
    cgPolygon(P), P^n #= 4,
    P^color #= blue,
    P^point(1) #= S^leftTopPoint,
    P^point(2) #= S^leftBottomPoint,
    P^point(3) #= S^rightBottomPoint,
    P^point(4) #= S^rightTopPoint.

pythagoras(P,N,Ps,PsR):-N=:=0,!,Ps=PsR.
pythagoras(P,N,Ps,PsR):-
    Ps=[T,P2,P3|Ps1],
    constrainTri(P,T),
    newPL(P,T,P2),
    newPR(P,T,P3),
    N1 is N-1,
    pythagoras(P2,N1,Ps1,Ps2),
    pythagoras(P3,N1,Ps2,PsR).


 constrainTri(P,T):-
    cgTriangle(T),
    T^color #= cyan,
    T^x2 #= P^x(1),
    T^y2 #= P^y(1),
    T^x3 #= P^x(4),
    T^y3 #= P^y(4),
    T^x1 #= P^x(1) + P^x(4) - (P^x(1) + P^x(3))//2,
    T^y1 #= P^y(1) + P^y(4) - (P^y(1) + P^y(3))//2.


 newPL(P,T,PL):-
   cgPolygon(PL),
   PL^n #= 4,
   PL^color #=blue,
   PL^x(2)  #= T^x1,
   PL^y(2) #= T^y1,
   PL^x(3) #= P^x(1),
   PL^y(3) #= P^y(1),
   PL^x(4) #= 2*P^x(1) - (P^x(3)+ P^x(1))//2,
   PL^y(4) #= 2*P^y(1) - (P^y(3)+ P^y(1))//2,
   PL^x(1) #= P^x(1) + P^x(4)- P^x(3),
   PL^y(1) #= P^y(1) + P^y(4) - P^y(3).

 newPR(P,T,PR):-
   cgPolygon(PR),
   PR^n #= 4,
   PR^color #=orange,
   PR^x(2)  #= T^x1,
   PR^y(2) #= T^y1,
   PR^x(3) #= P^x(4),
   PR^y(3) #= P^y(4),
   PR^x(4) #= 2*P^x(4) - (P^x(3)+ P^x(1))//2,
   PR^y(4) #= 2*P^y(4) - (P^y(3)+ P^y(1))//2,
   PR^x(1) #= 2*P^x(4)- P^x(3),
   PR^y(1) #= 2*P^y(4) - P^y(3).
