/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw the Chinese flag
*********************************************************************/
go:-
    china.

china:-
    china(Os),
    cgWindow(Win,"china"),Win^topMargin #= 30,Win^leftMargin #= 10,
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgShow(Os).


handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

china([R|Stars]):-
    cgDefaultWindow(Win),
    Win^leftMargin #= LM,
    Win^topMargin #= TM,
    cgRectangle(R), R^color #= red,
    Stars=[S0,S1,S2,S3,S4],
    cgStar(Stars), cgSame(Stars,color,yellow), cgSame(Stars,n,5),
    cgSame([S1,S2,S3,S4],width),
    %
    2*R^width #= 3*R^height,
    R^width #> 250,     R^width #< 500,
    %
/*
    5*S0^diameter #= R^width,
    3*S1^diameter #= S0^diameter,
    %
*/
    5*(S0^centerX-R^x) #= R^width,
  
    frozen(Cs),
    member(C,Cs),writeln(C),fail,

    S0^angle0 #= 90,

    3*(S1^centerX-R^x) #= R^width,
    10*(S1^centerY-R^y) #= R^height,
    S1^angle0 #= 70,

    25*(S2^centerX-R^x) #= 10*R^width,
    5*(S2^centerY-R^y) #= R^height,
    S2^angle0 #= 45,

    25*(S3^centerX-R^x) #= 10*R^width,
    3*(S3^centerY-R^y) #= R^height,
    S3^angle0 #= 90,

    3*(S4^centerX-R^x) #= R^width,
    21*(S4^centerY-R^y) #=< 10*R^height,
    23*(S4^centerY-R^y) #> 10*R^height,
    S4^angle0 #= 65.



