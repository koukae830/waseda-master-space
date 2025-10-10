go:-
    cgWindow(Win,"Test Triangle"),
    Win^topMargin #= 30, Win^leftMargin #= 15,
    handleWindowClosing(Win),
    cgSquare(R), R^window #= Win, R^width #= 300, 
    cgTriangle(T), T^window #= Win, T^color #= red,
    T^point1 #= R^topCenterPoint,
    T^point2 #= R^leftBottomPoint,
    T^point3 #= R^rightBottomPoint,
    cgPack([R,T]),
    cgShow(T),
    changeCursor(Win,T),
    handleMove(Win,T),
    handleSelect(Win,T).
    
handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

changeCursor(Win,T),{mouseMoved(Win,E)} =>
    E^x #= X, E^y #= Y,
    ((closeEnough(X,Y,x1,y1,T); closeEnough(X,Y,x2,y2,T);
      closeEnough(X,Y,x3,y3,T))->
     changeCursor1(Win,move_cursor);
     changeCursor1(Win,default_cursor)).

handleSelect(Win,T),{mousePressed(Win,E)} =>
    E^x #= X, E^y #= Y,
    (closeEnough(X,Y,x1,y1,T)-> global_set(selected,0,point(1,X,Y));
     closeEnough(X,Y,x2,y2,T)-> global_set(selected,0,point(2,X,Y));
     closeEnough(X,Y,x3,y3,T)-> global_set(selected,0,point(3,X,Y));
     global_del(selected,0)).

handleMove(Win,T),{mouseDragged(Win,E)} =>
    (global_get(selected,0,point(N,X0,Y0))->
     E^x #= X, E^y #= Y,
     changeCursor1(Win,move_cursor),
     movePoint(N,X,Y,T),
     cgShow(T);
     true).

changeCursor1(Win,CursorType):-
    cgGetCursor(Win,CursorType),!.
changeCursor1(Win,CursorType):-
    cgSetCursor(Win,CursorType).

movePoint(1,X,Y,T):-
    T^x1 #:= X,
    T^y1 #:= Y.
movePoint(2,X,Y,T):-
    T^x2 #:= X,
    T^y2 #:= Y.
movePoint(3,X,Y,T):-
    T^x3 #:= X,
    T^y3 #:= Y.

closeEnough(X,Y,Ax,Ay,T):-
    T^Ax #= X1,
    T^Ay #= Y1,
    sqrt((X-X1)*(X-X1)+(Y1-Y)*(Y1-Y)) < 5.
