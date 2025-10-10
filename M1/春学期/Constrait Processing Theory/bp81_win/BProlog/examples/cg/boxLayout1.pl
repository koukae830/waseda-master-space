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

    This program implements the forward checking algorithm. Once
    a box is laid out, all the no good points are excluded from 
    the domains of the remaining variables.
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
    placeBoxes(Boxes),
    write(Boxes),nl.

createPosVars([],AreaW,AreaH).
createPosVars([box(W,H,Pos,Color)|Boxes],AreaW,AreaH):-
    MaxX is AreaW-W,
    MaxY is AreaH-H,
    allPoints(0,0,MaxX,MaxY,D),
    Pos :: D,
    createPosVars(Boxes,AreaW,AreaH).

allPoints(X0,Y0,MaxX,MaxY,D):- % D=[(0,0),...,(0,MaxY),(1,0),...,(1,MaxY),...,(MaxX,0),...,(MaxX,MaxY)]
    range(X0,MaxX,Xs),
    range(Y0,MaxY,Ys),
    pair(Xs,Ys,D).

pair([],Ys,D):-D=[].
pair([X|Xs],Ys,D):-
    pair1(X,Ys,D,D1),
    pair(Xs,Ys,D1).

pair1(X,[],D,DRest):-D=DRest.
pair1(X,[Y|Ys],D,DRest):-D=[(X,Y)|D1],pair1(X,Ys,D1,DRest).

range(I,Max,Xs):-I>Max,!,Xs=[].
range(I,Max,Xs):-Xs=[I|Xs1],I1 is I+1,range(I1,Max,Xs1).

placeBoxes([]).
placeBoxes([Box|Boxes]):-
    Box=box(W,H,_,_),
    Dim is W*H,
    selectLargest(Boxes,Box,Dim,box(BW,BH,BPos,_),Rest),
    indomain(BPos),  % get a candidate position
    notOverlap(BW,BH,BPos,Rest),
    placeBoxes(Rest).

selectLargest([],Cur,Dim,Largest,Rest):-Largest=Cur,Rest=[].
selectLargest([Box|Boxes],Cur,Dim,Largest,Rest):-
    Box=box(W,H,_,_),
    Dim1 is W*H,
    (Dim1>Dim->LargerBox=Box,Rest=[Cur|Rest1],LargerDim=Dim1;
     LargerBox=Cur,LargerDim=Dim,Rest=[Box|Rest1]),
    selectLargest(Boxes,LargerBox,LargerDim,Largest,Rest1).
    
%The area of a laid out box as well as the left and top surrounding areas cannot be used for other boxes
%               _______________
%               |D |    C     |
%               ---------------
%               |  |          |
%               |B |    A     |
%               |  |          |
%               ---------------
notOverlap(W,H,(X,Y),Boxes):-
    MaxX is X+W-1,  
    MaxY is Y+H-1,
    allPoints(X,Y,MaxX,MaxY,PointsA),
    notOverlap(PointsA,X,Y,MaxX,MaxY,Boxes).

notOverlap(PointsA,X,Y,MaxX,MaxY,[]).
notOverlap(PointsA,X,Y,MaxX,MaxY,[box(W,H,PosVar,_)|Boxes]):-
    PosVar notin PointsA,
    X0 is X-W+1,
    Y0 is Y-H+1,
    allPoints(X0,Y,X,MaxY,PointsB),
    PosVar notin PointsB,
    %
    allPoints(X0,Y0,MaxX,Y,PointsCD),
    PosVar notin PointsCD,
    %
    notOverlap(PointsA,X,Y,MaxX,MaxY,Boxes).

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




