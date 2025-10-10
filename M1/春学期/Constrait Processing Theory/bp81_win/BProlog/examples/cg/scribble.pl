/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    Illustrate the use of most of the events
*********************************************************************/
/*
    Scribble with different colors of yellow, blue, and red. A color of is selected 
    through different means:
        select a menu item,
        select a choice item,
        select a list item,
        select a checkbox,
        click on a button,
        input through a text field, or
        type one keys of 'y', 'b', and 'r'.
    This example illustrates the usage of the following kinds of events:
        actionPerformed
        keyPressed
        mousePressed, mouseDragged, mouseReleased
        componentResized
        itemStateChanged
*/
go:-
    cgWindow(Win,"Test Event"),
    handleWindowClosing(Win),
    scribble(Os,Win),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

scribble([Area|Comps],Win):-
    %
    cgSetMenuBar(Win, MenuBar),
    cgMenu(Menu,"Color"),
    cgAdd(MenuBar,Menu),
    Ms=[My,Mb,Mr],
    cgMenuItem(Ms,["Yellow","Blue","Red"]),
    cgAdd(Menu,Ms),
    %
    cgList(List,["Yellow","Blue","Red"]),
    %
    cgChoice(Choice,["Yellow","Blue","Red"]),
    %
    Checks=[CheckYellow,CheckBlue,CheckRed],
    cgCheckboxGroup(Checks,["Yellow","Blue","Red"]),
    %
    Bs=[By,Bb,Br],
    cgButton(Bs,["Yellow","Blue","Red"]),
    %
    cgButton(Clean,"Clean"),
    %
    cgRectangle(Area),Area^fill #= 0,
    Area^width #= Win^width-List^width, Area^height #= Win^height,
    Area^width #> 3*List^width,
    cgLeft(List,Area),
    %
    cgTextField(Tf),
    cgTable([[List],[Choice],[By],[Bb],[Br],[CheckYellow],[CheckBlue],[CheckRed],[Tf],[Clean]],0,20),
    
    Comps=[List,Choice,CheckYellow,CheckBlue,CheckRed,Tf,Clean|Bs],
    %
    handleChangeColorEvents([My,Mb,Mr,By,Bb,Br,Tf],action,Area),
    handleChangeColorEvents([List,Choice],item,Area),
    handleChangeColorEvents([CheckYellow,CheckBlue,CheckRed],checkbox,Area),
    handleChangeColorEvents(Comps,key,Area),
    handleKeyEvent(Win,Area),
    handleWindowResizedEvent(Win,List,Area), %resize the area when the window is resized
    draw(Win,Area),
    handleCleanButtonClick(Clean,Win).

handleCleanButtonClick(Clean,Win),{actionPerformed(Clean)} =>
    cgClean(Win).

handleWindowResizedEvent(W,List,Area),{componentResized(W,E)} =>
    E^width #= Width,
    E^height #= Height,
    List^width #= ListWidth,
    NewWidth is Width-ListWidth,
    Area^width #:= NewWidth,
    Area^height #:= Height,
    cgShow(Area).

draw(W,Area):-
    global_set(color,0,yellow),     % initial color
    handleMousePressedEvent(W,Area),
    handleMouseDraggedEvent(W,Area),
    handleMouseReleasedEvent(W,Area).

handleMousePressedEvent(W,Area),{mousePressed(W,E)} =>
    E^x #= X,
    E^y #= Y,
    (insideArea(X,Y,Area)->
     global_set(prevPoint,0,point(X,Y));true).

handleMouseDraggedEvent(W,Area),{mouseDragged(W,E)} =>
    E^x #= X,
    E^y #= Y,
    drawLine(X,Y,Area),
    global_set(prevPoint,0,point(X,Y)).

handleMouseReleasedEvent(W,Area),{mouseReleased(W,E)} =>
    global_del(prevPoint,0). % delete the global variable

drawLine(X,Y,Area):-
    insideArea(X,Y,Area),
    global_get(prevPoint,0,point(X1,Y1)),!,
    cgLine(L),L^window#=Area^window,
    L^x1 #= X1, L^y1 #= Y1,
    L^x2 #= X, L^y2 #= Y,
    global_get(color,0,Color),
    L^color #= Color,
    cgShow(L),
    global_set(prevPoint,0,point(X,Y)).
drawLine(X,Y,Area).

insideArea(X,Y,Area):-
    Area^x #= MinX,
    Area^y #= MinY,
    Area^width #= W,
    Area^height #= H,
    X >= MinX, X=<MinX+W,
    Y >= MinY, Y=<MinY+H.

handleChangeColorEvents([],_,_Area).
handleChangeColorEvents([B|Bs],Type,Area):-
    handleChangeColorEvent(B,Type,Area),
    handleChangeColorEvents(Bs,Type,Area).

handleChangeColorEvent(Comp,action,Area):-
    handleActionEvent(Comp,Area).
handleChangeColorEvent(Comp,item,Area):-
    handleItemEvent(Comp,Area).
handleChangeColorEvent(Comp,key,Area):-
    handleKeyEvent(Comp,Area).
handleChangeColorEvent(Comp,checkbox,Area):-
    handleCheckboxItemEvent(Comp,Area).

handleActionEvent(C,Area),{actionPerformed(C)} =>
    cgGetText(C,String),
    changeColor(String).


handleKeyEvent(Comp,Area),{keyPressed(Comp,E)} =>
    E^char #= Char,
    changeColor(Char).

handleItemEvent(C,Area),{itemStateChanged(C,E)} =>
    cgSelectedItem(C,Lab),
    changeColor(Lab).

handleCheckboxItemEvent(C,Area),{itemStateChanged(C,E)} =>
    cgGetText(C,String),
    changeColor(String).

changeColor(Command):-
    changeColor(Command,NewColor),!,
    global_set(color,0,NewColor).
changeColor(Command).

changeColor("Yellow",yellow). % buttons, menu items,
changeColor("Blue",blue).
changeColor("Red",red).
changeColor('Y',yellow).      % key strokes
changeColor(y,yellow).
changeColor('B',blue).
changeColor(b,blue).
changeColor(r,red).
changeColor('R',red).
changeColor(0,yellow).        % list and choice items
changeColor(1,blue).
changeColor(2,red).




