/*  Purpose: Solve the box packing problem.
    Author: Neng-Fa Zhou, 2002
    Platform: B-Prolog 6.1 or up

    Description:

    The dimensions of the boxes are give by the relation box/1
    and the layout area is defined by the predicate area/2.
    For each box, let W and H be the width and the height box, 
    respectively, and AreaW and AreaH be the width and height 
    of the layout area, respectively. The domain of positions
    for the box is:
    
         [(0,0),...,(AreaW-W,AreaH-H)]

    This program implement the forward checking algorithm. Once
    a box is laid out, all the points taken by the box are 
    excluded from the domains of the remaining variables.
*/

go:-
    findall(box(W,H,_),box(W,H),Boxes),  %box(Width,Height,PosVar)
    area(AreaW,AreaH),  % layout area
    createPosVars(Boxes,AreaW,AreaH),
    placeBoxes(Boxes),
    write(Boxes),nl.

createPosVars([],AreaW,AreaH).
createPosVars([box(W,H,Pos)|Boxes],AreaW,AreaH):-
    FeasibleW is AreaW-W,
    FeasibleH is AreaH-H,
    allPoints(0,0,FeasibleW,FeasibleH,D),
    Pos :: D,
    createPosVars(Boxes,AreaW,AreaH).

allPoints(X0,Y0,MaxX,MaxY,D):- % D=[(0,0),...,(0,MaxY),(1,0),...,(1,MaxY),...,(MaxX,0),...,(MaxX,MaxY)]
    range(X0,MaxX,Xs),
    range(Y0,MaxY,Ys),
    pair(Xs,Ys,D).
%    findall((X,Y),(member(X,Xs),member(Y,Ys)),D).

pair([],Ys,D):-D=[].
pair([X|Xs],Ys,D):-
    pair1(X,Ys,D,D1),
    pair(Xs,Ys,D1).

pair1(X,[],D,DRest):-D=DRest.
pair1(X,[Y|Ys],D,DRest):-D=[(X,Y)|D1],pair1(X,Ys,D1,DRest).

range(I,Max,Xs):-I>Max,!,Xs=[].
range(I,Max,Xs):-Xs=[I|Xs1],I1 is I+1,range(I1,Max,Xs1).

placeBoxes([]).
placeBoxes([box(W,H,Pos)|Boxes]):-
    indomain(Pos),  % get a candidate position
    notOverlap(W,H,Pos,Boxes),
    placeBoxes(Boxes).
    
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
notOverlap(PointsA,X,Y,MaxX,MaxY,[box(W,H,PosVar)|Boxes]):-
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

area(33,24).

box(3,9).
box(6,6).
box(9,6).
box(9,3).
box(12,3).
box(12,6).
box(3,12).
box(6,9).
box(6,12).
box(6,3).
box(21,3).
box(9,9).
box(3,18).
