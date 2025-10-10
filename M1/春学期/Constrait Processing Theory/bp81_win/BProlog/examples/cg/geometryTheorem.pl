/* demonstrate a geometry theorem on quadrilaterals: 
    The quadrilateral formed by the four middle points of 
    another quadrilateral is always parallelogram.
*/
go:-
    cgWindow(Win,"geometryTheorem"), Win^topMargin #= 100, Win^leftMargin #= 100,
    handleWindowClosing(Win), Win^width #>600, Win^height #> 700,
    cgRectangle(R),R^fill #=0,R^window #= Win,
    R^width #= 400, R^height #= 500,
    cgPack(R),
    cgPolygon(Q), Q^n #= 4, Q^fill #= 0,
    Q^point(1) #= R^leftTopPoint,
    Q^point(2) #= R^leftBottomPoint,
    Q^point(3) #= R^rightBottomPoint,
    Q^point(4) #= R^rightTopPoint,
    cgPolygon(P),P^n #= 4,P^fill #= 0,
    cgSame([P,Q],window,Win),
    cgPack(Q),
    middle(P,Q),
    State=pointSelected(0),
    handleChange(Win,Q,P,State),
    cgShow([P,Q]).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

middle(P,Q):-    
    middle(P,Q,1,2),
    middle(P,Q,2,3),
    middle(P,Q,3,4),
    middle(P,Q,4,1).

middle(P,Q,I,J):-
    P^xs(I) #:= (Q^xs(I)+Q^xs(J))//2,
    P^ys(I) #:= (Q^ys(I)+Q^ys(J))//2.

handleChange(Win,Q,P,State):-
    handleMouseMove(Win,Q),
    handleMouseDown(Win,Q,P,State),
    handleMouseUp(Win,Q,P,State),
    handleMouseDrag(Win,Q,P,State).
    
handleMouseMove(Win,Q),{mouseMoved(Win,E)} =>
    E^x #= X, E^y #= Y,
    ((closeEnough(X,Y,1,Q);
      closeEnough(X,Y,2,Q);
      closeEnough(X,Y,3,Q);
      closeEnough(X,Y,4,Q))->
     changeCursor(Win,move_cursor);
     changeCursor(Win,default_cursor)).

handleMouseDown(Win,Q,P,State),{mousePressed(Win,E)} =>
    critical_region(selectPoint(E,Q,State)).

handleMouseUp(Win,Q,P,State),{mouseReleased(Win,E)} =>
    setarg(1,State,0).

handleMouseDrag(Win,Q,P,State),{mouseDragged(Win,E)} =>
    arg(1,State,I),
    (I>0 ->
     E^x #= X,
     E^y #= Y,
     Q^xs(I) #:= X,
     Q^ys(I) #:= Y,
     middle(P,Q),
     cgShow([P,Q]),
     changeCursor(Win,move_cursor);
     true).

selectPoint(E,Q,State):-
    E^x #= X,
    E^y #= Y,
    (closeEnough(X,Y,1,Q)->setarg(1,State,1);true),
    (closeEnough(X,Y,2,Q)->setarg(1,State,2);true),
    (closeEnough(X,Y,3,Q)->setarg(1,State,3);true),
    (closeEnough(X,Y,4,Q)->setarg(1,State,4);true).

closeEnough(X,Y,I,Q):-
    Q^xs(I) #= X1,
    Q^ys(I) #= Y1,
    sqrt((X-X1)*(X-X1)+(Y1-Y)*(Y1-Y)) < 5.

changeCursor(Win,CursorType):-
    cgGetCursor(Win,CursorType),!.
changeCursor(Win,CursorType):-
    cgSetCursor(Win,CursorType).
    





