/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    moving a box
*********************************************************************/
go:-
    cgWindow(Win,"movingBox"),
    handleWindowClosing(Win),
    moving(Os,Win),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

moving(Os,Win):-
    cgSquare(Box), Box^color #= red, Box^width #> 100,
    handleMousePressed(Win,Box),
    handleMouseDragged(Win,Box),
    handleMouseReleased(Win,Box),
    handleWindowClosing(Win),
    Os=[Box].

handleMousePressed(Win,Box),{mousePressed(Win,E)} =>
    E^x #= X,
    E^y #= Y,
    (insideBox(X,Y,Box)->global_set(boxSelected,0,point(X,Y));true).

handleMouseReleased(Win,Box),{mouseReleased(Win,E)} =>
    E^x #= X,
    E^y #= Y,
    (global_get(boxSelected,0,point(X0,Y0))->
     moveBox(Box,X0,Y0,X,Y),
     global_del(boxSelected,0);
     true).

handleMouseDragged(Win,Box),{mouseDragged(Win,E)} =>
    E^x #= X,
    E^y #= Y,
    (global_get(boxSelected,0,point(X0,Y0))->
     global_set(boxSelected,0,point(X,Y)),
     moveBox(Box,X0,Y0,X,Y);
     true).

insideBox(X,Y,Box):-
    Box^x #= MinX,
    Box^y #= MinY,
    Box^width #= W,
    Box^height #= H,
    X >= MinX, X=<MinX+W,
    Y >= MinY, Y=<MinY+H.

moveBox(Box,X0,Y0,X1,Y1):-
    Box^x #= X,
    Box^y #= Y,
    NewX is X1-X0+X,
    NewY is Y1-Y0+Y,
    Box^x #:= NewX,
    Box^y #:= NewY,
    write(show(Box)),nl,
    cgShow(Box).


