/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw a rectangle, a circle, and another rectangle in the same row
*********************************************************************/
go:-
    cgRectangle(R1),R1^width #= 50, R1^height #= 50,
    cgCircle(C), C^diameter #= R1^height,
    cgRectangle(R2), R2^size #= R1^size,
    Comps=[R1,C,R2],
    cgWindow(Win,"recCircleRec"),Win^topMargin #= 50,
    handleWindowClosing(Win),
    cgSame(Comps,window,Win),
    cgSameRow(Comps),
    cgShow(Comps).
go.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).


