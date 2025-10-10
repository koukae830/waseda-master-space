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

*/

go:-
    findall(box(W,H,_),box(W,H),Boxes),  %box(Width,Height,PosVar)
    area(AreaW,AreaH),  % layout area
    createPosVars(Boxes,AreaW,AreaH,PosVars),
    writeln(PosVars),
    labeling_mix(PosVars,1000,Result),
    writeln(Boxes),
    writeln(Result).

createPosVars([],AreaW,AreaH,[]).
createPosVars([box(W,H,(PosX,PosY))|Boxes],AreaW,AreaH,[PosX,PosY|PosVars]):-
    PosX :: 0..AreaW-W,
    PosY :: 0..AreaH-H,
    notOverlap(W,H,PosX,PosY,Boxes),
    createPosVars(Boxes,AreaW,AreaH,PosVars).

notOverlap(W,H,X,Y,[]).
notOverlap(W,H,X,Y,[box(W1,H1,(X1,Y1))|Boxes]):-
    (X+W #=< X1 #\/ X1+W1 #=< X #\/ Y+H #=< Y1 #\/ Y1+H1 #=< Y),
    notOverlap(W,H,X,Y,Boxes).


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
