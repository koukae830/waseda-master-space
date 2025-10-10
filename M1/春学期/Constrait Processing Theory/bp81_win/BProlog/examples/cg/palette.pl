/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    A palette of colors
*********************************************************************/
go:-
    cgWindow(Win,"Palette"),Win^topMargin #= 50, Win^leftMargin #= 50,
    Win^width #>1000,
    handleWindowClosing(Win),
    palette("Red","Green","Blue",Palette1,Os1),
    palette("Green","Blue","Red",Palette2,Os2),
    palette("Blue","Red","Green",Palette3,Os3),
    cgLeft(Os1,Os2),
    cgLeft(Os2,Os3),
    cgSame(Os1,window,Win), 
    cgSame(Os2,window,Win), 
    cgSame(Os3,window,Win), 
    handleWindowClosing(Win),
    cgStartRecord(palette),
    cgShow(Os1),cgShow(Os2),cgShow(Os3),
    cgStopRecord.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

palette(C1,C2,C3,Palette,Os):-
    cgLabel([L1,L2,L3],[C1,C2,C3]), % labels for colors
    cgTextField(Tf1),cgSetText(Tf1,"0"),Tf1^columns #= 4, 
    new_array(Palette,[19,19]),
    createLabels(2,19,Palette),
    createSquares(2,19,Palette),    
    cgGrid(Palette),
    Palette^[19,19] @= Grid, Grid^width #= 15,Grid^height #= 15,
    cgSameRow([L1,Tf1]), cgAbove(L1,L2),
    leftCenter(L2,Palette),
    topCenter(L3,Palette),
    %
    array_to_list(Palette,[_|Os1]), % ignore the square at [1,1]
    Os=[L1,L2,L3,Tf1|Os1],
    %
    changeColors(0,C1,C2,C3,Palette),
    handleColorInput(Tf1,C1,C2,C3,Palette,Os1).

createLabels(I,N,Palette):-I=<N,!,
    Scale is (I-2)*15,
    number_codes(Scale,ScaleString),
    cgLabel(L11,ScaleString),L11^fontSize#=8,
    cgLabel(L22,ScaleString),L22^fontSize#=8,
    Palette^[1,I] @= L11,
    Palette^[I,1] @= L22,
    I1 is I+1,
    createLabels(I1,N,Palette).
createLabels(I,N,Palette).

createSquares(I,N,Palette):-I=<N,!,
    createSquares(I,2,N,Palette),
    I1 is I+1,
    createSquares(I1,N,Palette).
createSquares(I,N,Palette).

createSquares(I,J,N,Palette):-J=<N,!,
    cgSquare(S),
    Palette^[I,J] @= S,
    J1 is J+1,
    createSquares(I,J1,N,Palette).
createSquares(I,J,N,Palette).

leftCenter(Comp,Palette):-
    Palette^dimension @= [N,M],
    Palette^[1,1] @= Comp1,
    Palette^[N,1] @= Comp2,
    cgLeft(Comp,Comp1),
    Comp^y #= (Comp1^y+Comp2^y)//2.

topCenter(Comp,Palette):-
    Palette^dimension @= [N,M],
    Palette^[1,1] @= Comp1,
    Palette^[1,M] @= Comp2,
    cgAbove(Comp,Comp1),
    Comp^x #= (Comp1^x+Comp2^x)//2.

handleColorInput(Tf,C1,C2,C3,Palette,Os),{actionPerformed(Tf)} =>
    cgGetText(Tf,Text),
    catch(number_codes(Scale1,Text),Exception,true), %if malformed, ignore it
    (var(Scale1)->true;
     catch(changeColors(Scale1,C1,C2,C3,Palette),_,true),
     cgShow(Os)).

changeColors(Scale1,C1,C2,C3,Palette):-
    changeColors(2,19,Scale1,C1,C2,C3,Palette). % for each I in 2..19 and J in 2..19, set the color for Palette^[I,J]

changeColors(I,N,Scale1,C1,C2,C3,Palette):-I=<N,!,
    changeColors(I,2,N,Scale1,C1,C2,C3,Palette),
    I1 is I+1,
    changeColors(I1,N,Scale1,C1,C2,C3,Palette).
changeColors(I,N,Scale1,C1,C2,C3,Palette).

changeColors(I,J,N,Scale1,C1,C2,C3,Palette):-J=<N,!,
    Scale2 is (I-2)*15,
    Scale3 is (J-2)*15,
    cgColor(Color),
    setRGBValue(C1,Scale1,Color),
    setRGBValue(C2,Scale2,Color),
    setRGBValue(C3,Scale3,Color),
    Palette^[I,J] @= Square,
    Square^color #:= Color,
    J1 is J+1,
    changeColors(I,J1,N,Scale1,C1,C2,C3,Palette).
changeColors(I,J,N,Scale1,C1,C2,C3,Palette).
    
setRGBValue("Red",Scale,Color):-!,Color^red#=Scale.
setRGBValue("Green",Scale,Color):-!,Color^green#=Scale.
setRGBValue("Blue",Scale,Color):-!,Color^blue#=Scale.



