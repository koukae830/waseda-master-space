/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw fancy circles
*********************************************************************/
go:-
    circles.
go.

circles:-
    N=31,
    functor(T,circles,N),
    T=..[_|Circles],Circles=[C0|_],
    cgCircle(Circles),
    C0^width #>500,
    %
    cgSame(Circles,centerY),
    constrainSize(T,1,N),
    constrainColor(Circles),
    %
    cgWindow(Win,"circles"), Win^topMargin #= 20, Win^width #> 600, Win^height #> 600,
    handleWindowClosing(Win),
    cgSame(Circles,window,Win),
    cgPack(Circles),
    cgStartRecord(circles),
    cgShow(Circles),
    cgStopRecord.

constrainSize(T,N0,N):-
    2*N0<N,!,
    I is 2*N0,
    J is 2*N0+1,
    arg(N0,T,C0),
    arg(I,T,C1),
    arg(J,T,C2),
    C0^diameter #= 2*C1^diameter,
    C2^diameter #= C1^diameter,
    C1^x #= C0^x, C2^x #= C0^centerX,
    N1 is N0+1,
    constrainSize(T,N1,N).
constrainSize(_T,_N0,_N).

%two circles that are of the same size must have the same color
%and two circles that are of different sizes must have different colors
constrainColor([]):-!.
constrainColor([_]):-!.
constrainColor([C|Cs]):-
    constrainColor(C,Cs),
    constrainColor(Cs).

constrainColor(_C,[]).
constrainColor(C,[C1|Cs]):-
    C^color #\= black, C^color #\= darkGray, C^color #\= gray, C^color #\= blue,
    (C^diameter #= C1^diameter) #=> C^color #= C1^color,
    (C^diameter #\= C1^diameter) #=> C^color #\= C1^color,     
     constrainColor(C,Cs).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).
