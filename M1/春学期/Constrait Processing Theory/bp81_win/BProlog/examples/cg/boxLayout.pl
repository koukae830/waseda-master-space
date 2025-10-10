/*  Purpose: Solve the box packing problem.
    Author: Neng-Fa Zhou, 2002
    Platform: B-Prolog 6.1 or up

    Description:

    The dimensions of the boxes are give by the relation box/1
    and the layout area is defined by the predicate area/2.
    For each box, let W and H be the width and the height, 
    respectively, and AreaW and AreaH be the width and height 
    of the layout area, respectively. The domain of positions
    for the box is:
    
         [(0,0),...,(AreaW-W,AreaH-H)]

*/

go:-
    solve(Boxes),
    visualize(Boxes).

visualize(Boxes):-
    cgWindow(Win,"boxLayout"),
    handleWindowClosing(Win),
    createRects(Boxes,Os),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgMove(Os,30,30),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

createRects([],[]).
createRects([box(W,H,(X,Y),C)|Boxes],[Rect|Rects]):-
    cgRectangle(Rect),
    Rect^width #= 10*W,
    Rect^height #= 10*H,
    Rect^x #= 10*X,
    Rect^y #= 10*Y,
    Rect^color #= C,
    createRects(Boxes,Rects).

/* pack the boxes */
solve(Boxes):-
    findall(box(W,H,_,C),box(W,H,C),Boxes),  %box(Width,Height,PosVar)
    area(AreaW,AreaH),  % layout area
    createPosVars(Boxes,AreaW,AreaH),
    placeBoxes(Boxes).

createPosVars([],AreaW,AreaH).
createPosVars([box(W,H,Pos,Color)|Boxes],AreaW,AreaH):-
    Pos=(X,Y),
    X in 0..AreaW-W,
    Y in 0..AreaH-H,
    notOverlap(W,H,X,Y,Boxes),
    createPosVars(Boxes,AreaW,AreaH).

notOverlap(W,H,X,Y,[]).
notOverlap(W,H,X,Y,[box(W1,H1,(X1,Y1),_)|Boxes]):-
    (X+W #=< X1 #\/ X1+W1 #=< X #\/ Y+H #=< Y1 #\/ Y1+H1 #=< Y),
    notOverlap(W,H,X,Y,Boxes).

placeBoxes([]).
placeBoxes([Box|Boxes]):-
    Box=box(W,H,_,_),
    Dim is W*H,
    selectLargest(Boxes,Box,Dim,box(BW,BH,(X,Y),_),Rest),
    indomain(X), indomain(Y),
    placeBoxes(Rest).

selectLargest([],Cur,Dim,Largest,Rest):-Largest=Cur,Rest=[].
selectLargest([Box|Boxes],Cur,Dim,Largest,Rest):-
    Box=box(W,H,_,_),
    Dim1 is W*H,
    (Dim1>Dim->LargerBox=Box,Rest=[Cur|Rest1],LargerDim=Dim1;
     LargerBox=Cur,LargerDim=Dim,Rest=[Box|Rest1]),
    selectLargest(Boxes,LargerBox,LargerDim,Largest,Rest1).
    
area(30,21).

box(3,9,darkGray).
box(6,6,blue).
box(9,6,cyan).
box(9,3,orange).
box(12,3,lightGray).
box(12,6,pink).
box(3,12,magenta).
box(6,9,gray).
box(6,12,green).
box(6,3,red).
box(21,3,black).
box(9,9,red).
box(3,18,yellow).




