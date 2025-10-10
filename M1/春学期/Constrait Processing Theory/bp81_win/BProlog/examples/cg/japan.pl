/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw the Japanese flag
*********************************************************************/
go:-
    japan(Os),
    cgWindow(Win,"japan"),Win^topMargin #= 30, Win^leftMargin #= 10,
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgShow(Os).

japan([Flag,Frame,Sun]):-
    cgRectangle(Flag), Flag^color #= white, Flag^width #> 200,
    cgRectangle(Frame), Frame^color #= black, Frame^fill #= 0,
    cgCircle(Sun), Sun^color #= red,

    cgSame([Frame,Flag],location),
    cgSame([Frame,Flag],size),
    cgSame([Sun,Frame],center),

    5*Flag^width #= 7*Flag^height,
    7*Sun^width #= 3*Flag^height.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

