/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    Drawing the flag of AntiguaAndBarbuda
*********************************************************************/
go:-
    poland.
go.

poland:-
    poland(Os),
    cgWindow(Win,"Poland"), Win^topMargin #= 40, Win^leftMargin #= 10,
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgShow(Os).

poland([R,RR]):-
    cgRectangle([R,RR]), 
    R^color #= black, R^fill #= 0,
    2*R^width #= 3*R^height,
    R^width #> 500,

    RR^color #= red,
    RR^width #= R^width,
    RR^height #= R^height//2,
    RR^x #= R^x,
    RR^y #= R^centerY.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).
