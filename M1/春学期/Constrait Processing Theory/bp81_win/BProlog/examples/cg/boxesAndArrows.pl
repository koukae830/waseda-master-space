/*  
    A boxes-and-arrows editor. Whenever a box is deleted, all 
    the outgoing and incoming arrows will be deleted automatically. 
    Whenever a box is moved, all the attached arrows will be moved
    accordingly. 
    By Neng-Fa Zhou, (C) all rights reserved.
*/

go:-
    cgStartRecord(boxesAndArrows),
    cgWindow(Win,"Boxes-and-Arrows Editor"),
    Win^topMargin #= 30, Win^leftMargin #= 15,
    createToolPan(Win,ToolPan,LButton,AButton,DButton,QButton),
    cgRectangle(Area),Area^fill #= 0,
    Area^width #= Win^width-ToolPan^width-10,
    Area^height #= Win^height-40,
    Area^window#=Win,
    cgLeft(ToolPan,Area),
    handleWindowResize(Win,ToolPan,Area),
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,0,0,nil,[],[]),
           % the position for the next label is <0,0>
           % current selected component is nil
           % lists of boxes and arrows are []
    cgShow(Area),
    handleWindowClosing(Win),
    handleMousePressed(Win,BA),
    handleMouseDragged(Win,BA),
    handleKeyPressed(Win,BA),
    handleKeyTyped(Win,BA).

handleWindowClosing(Win),{windowClosing(Win)} => cgStopRecord,cgClose(Win).

handleWindowResize(Win,ToolPan,Area),{componentResized(Win,E)} =>
    Area^width #:= Win^width-ToolPan^width-10,
    Area^height #:= Win^height-40,
    cgShow(Area).

handleMousePressed(Win,BA),{mousePressed(Win,E)} =>
    E^x #= X, E^y #= Y,
    (cgIsRightButton(E)->nl,setSelected(BA,nil);
     cgIsLeftButton(E)->handleMousePress(BA,X,Y);
     true).

handleMousePress(BA,X,Y):- %arrow button was selected
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,AButton,Boxes,Arrows),
    inside(X,Y,Area),
    boxClicked(Boxes,X,Y,Box),!,
    setSelected(BA,arrowStart(Box)).
handleMousePress(BA,X,Y):- %starting point of the arrow was selected
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,arrowStart(Box1),Boxes,Arrows),
    inside(X,Y,Area),
    boxClicked(Boxes,X,Y,Box2),!,/* ending point of the arrow */
    cgLine(Arrow),
    Arrow^x1 #= Box1^centerX, Arrow^y1 #= Box1^centerY,
    Arrow^x2 #= Box2^centerX, Arrow^y2 #= Box2^centerY,
    Arrow^arrow2 #= 1,
    Arrow^window #= Win,
    addArrow(BA,arrow(Arrow,Box1,Box2)),
    setSelected(BA,nil),
    cgShow(Arrow).
handleMousePress(BA,X,Y):- %label button was selected
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    Selected==LButton,
    inside(X,Y,Area),!, % new label
    setSelected(BA,newLabel(TextBox)),
    cgTextBox(TextBox),
    TextBox^x #= X,
    TextBox^y #= Y,
    TextBox^window #= Win,
    cgSetText(TextBox,""),
    cgPack(TextBox),
    addBox(BA,TextBox).
handleMousePress(BA,X,Y):- %finish inputting a label
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,newLabel(TextBox),Boxes,Arrows),!,
    setSelected(BA,nil),
    handleMousePress(BA,X,Y).
handleMousePress(BA,X,Y):-
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    inside(X,Y,Area),!, % select
    setPosition(BA,X,Y),
    (boxClicked(Boxes,X,Y,Box)->setSelected(BA,selected(Box));
     arrowClicked(Arrows,X,Y,Arrow)->setSelected(BA,selected(Arrow));
     true).
handleMousePress(BA,X,Y):-
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    inside(X,Y,LButton),!,
    setSelected(BA,LButton).     
handleMousePress(BA,X,Y):-
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    inside(X,Y,AButton),!,
    setSelected(BA,AButton).     
handleMousePress(BA,X,Y):-
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    inside(X,Y,DButton),!,
    deleteBoxOrArrow(BA).
handleMousePress(BA,X,Y):-
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    inside(X,Y,QButton),!,
    halt.
handleMousePress(BA,X,Y).

%%
handleMouseDragged(Win,BA),
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    {mouseDragged(Win,E)} 
    =>
    ((Selected=selected(Box),cgTextBox(Box)) ->
     E^x #= X, E^y #= Y,
     (inside(X,Y,Area) ->
      Box^x #:= Box^x+X-X0,
      Box^y #:= Box^y+Y-Y0,
      setPosition(BA,X,Y),
      cgShow(Box),
      adjustArrows(Arrows,Box);
      true)
     ;
     true).

adjustArrows([],SelectedBox).
adjustArrows([arrow(Arrow,SelectedBox,Box2)|Arrows],SelectedBox):-!,
    Arrow^x1 #:= SelectedBox^centerX,
    Arrow^y1 #:= SelectedBox^centerY,
    cgShow(Arrow),
    adjustArrows(Arrows,SelectedBox).
adjustArrows([arrow(Arrow,Box1,SelectedBox)|Arrows],SelectedBox):-!,
    Arrow^x2 #:= SelectedBox^centerX,
    Arrow^y2 #:= SelectedBox^centerY,
    cgShow(Arrow),
    adjustArrows(Arrows,SelectedBox).
adjustArrows([_|Arrows],SelectedBox):-
    adjustArrows(Arrows,SelectedBox).
%%
handleKeyPressed(Win,BA),
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    {keyPressed(Win,E)} 
    =>
    E^code #= Code,
    (vk_DELETE(Code)->
     deleteBoxOrArrow(BA);true).


handleKeyTyped(Win,BA),{keyTyped(Win,E)} =>
    E^char #= Char,
    (getSelected(BA,newLabel(TextBox))->
     char_code(Char,Code),
     cgGetText(TextBox, CurText),
     append(CurText,[Code],NewText),
     cgTextBox(Temp),
     cgSetText(Temp,NewText),
     cgPack(Temp), % get the width of the new label
     TextBox^width #:= Temp^width,
     cgSetText(TextBox,NewText),
     cgShow(TextBox);
     true).

%%
createToolPan(Win,ToolPan,LButton,AButtonBox,DButton,QButton):-
    cgRectangle(ToolPan),
    ToolPan^width #= 100,
    cgTextBox(LButton,"Label"), 
    %
    cgRectangle(AButtonBox),
    AButtonBox^fill #= 0,
    cgLine(AButton),
    AButton^y1 #= AButton^y2,
    AButton^y1 #= AButtonBox^centerY,
    AButton^x1 #= AButtonBox^x,
    AButton^x2 #= AButtonBox^rightX,
    AButton^arrow2 #= 1,
    %
    cgTextBox(DButton," Delete "), 
    cgTextBox(QButton," Quit "), 
    cgSetAlignment([LButton,DButton,QButton],center),
    %
    cgRectangle(Pad),Pad^height #= 100,
    cgTable([[LButton],[AButtonBox],[Pad],[DButton],[QButton]],0,5),
    %
    cgSame([ToolPan,LButton,AButtonBox,AButton,DButton,QButton,Pad],window,Win),
    cgInside([LButton,AButtonBox,DButton,QButton],ToolPan),
    cgShow([LButton,AButton,AButtonBox,DButton,QButton]).

%%
% operations on ba(Win,Area,LButton,AButton,DButton,QButton,X,Y,Selected,Boxes,Arrows), 
boxClicked([Box|Boxes],X,Y,Box):-
     inside(X,Y,Box),!.
boxClicked([_|Boxes],X,Y,Box):-
     boxClicked(Boxes,X,Y,Box).

arrowClicked([arrow(Arrow,_,_)|Arrows],X,Y,Arrow):-
    Arrow^x1 #= X1,
    Arrow^y1 #= Y1,
    Arrow^x2 #= X2,
    Arrow^y2 #= Y2,
    D1 is sqrt((X-X1)*(X-X1)+(Y-Y1)*(Y-Y1)),
    D2 is sqrt((X-X2)*(X-X2)+(Y-Y2)*(Y-Y2)),
    D3 is sqrt((X1-X2)*(X1-X2)+(Y1-Y2)*(Y1-Y2)),
    U is (D3*D3+D1*D1-D2*D2)/(2*D3),
    D is sqrt(D1*D1-U*U), %distance between <X,Y> and the line
    D=<5,!.
arrowClicked([_|Arrows],X,Y,Arrow):-
     arrowClicked(Arrows,X,Y,Arrow).

setPosition(BA,X,Y):-
    setarg(7,BA,X),
    setarg(8,BA,Y).

getSelected(BA,Selected):-    
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows).

setSelected(BA,Comp):-    
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    changeColor(Selected,black),
    setarg(9,BA,Comp),
    changeColor(Comp,lightGray).

changeColor(selected(Comp),Color):-
    Comp^color #:= Color,
    cgShow(Comp).
changeColor(arrowStart(Comp),Color):-
    Comp^color #:= Color,
    cgShow(Comp).
changeColor(_,_).

addArrow(BA,Arrow):-
     BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
     setarg(11,BA,[Arrow|Arrows]).
     
addBox(BA,TextBox):-
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,Selected,Boxes,Arrows),
    setarg(10,BA,[TextBox|Boxes]).

deleteBoxOrArrow(BA):-
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,selected(Comp),Boxes,Arrows),
    cgLine(Comp),!, % arrow
    delete(arrow(Comp,_,_),Arrows,Arrows1),
    setarg(11,BA,Arrows1),
    cgClean(Comp),
    setarg(9,BA,nil),
    cgShow(Win).
deleteBoxOrArrow(BA):-
    BA=ba(Win,Area,LButton,AButton,DButton,QButton,X0,Y0,selected(Box),Boxes,Arrows),
    delete(Box,Boxes,Boxes1),
    deleteAttachedArrows(Arrows,Box,Arrows1),
    setarg(11,BA,Arrows1),
    setarg(10,BA,Boxes1),
    cgClean(Box),
    setarg(9,BA,nil),
    cgShow(Win).
deleteBoxOrArrow(BA).

deleteAttachedArrows([],DeletedBox,NArrows):-NArrows=[].
deleteAttachedArrows([arrow(Arrow,DeletedBox,Box2)|Arrows],DeletedBox,NArrows):-!,
    cgClean(Arrow),
    deleteAttachedArrows(Arrows,DeletedBox,NArrows).
deleteAttachedArrows([arrow(Arrow,Box1,DeletedBox)|Arrows],DeletedBox,NArrows):-!,
    cgClean(Arrow),
    deleteAttachedArrows(Arrows,DeletedBox,NArrows).
deleteAttachedArrows([Arrow|Arrows],DeletedBox,NArrows):-!,
    NArrows=[Arrow|NArrowsR],
    deleteAttachedArrows(Arrows,DeletedBox,NArrowsR).

inside(X,Y,Comp):-
     Comp^x #= X0,
     Comp^y #= Y0,
     Comp^width #= W,     
     Comp^height #= H,
     X>=X0, Y>=Y0,
     X=<X0+W, Y=<Y0+H.

delete(X,Xs,Ys):-append(L,[X|R],Xs),append(L,R,Ys),!.

%% utilities in B-Prolog
/*
closeTail(Xs):-var(Xs),!,Xs=[].
closeTail([_|Xs]):-closeTail(Xs).

attach(X,Xs):-var(Xs),!,Xs=[X|_].
attach(X,[_|Xs]):-attach(X,Xs).
*/
