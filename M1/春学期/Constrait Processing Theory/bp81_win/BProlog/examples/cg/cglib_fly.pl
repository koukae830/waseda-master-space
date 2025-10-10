
% by Neng-Fa Zhou
page:-
    cgWindow(Win,"CGLIB"),
    Win^width #= 800, Win^height #= 800,
    
% title and framework
    cgRectangle(Margin),Margin^height #= 60,

    cgLabel(Title,"CGLIB: A Constraint-based Graphics Library for B-Prolog"),
    cgAbove(Margin,Title),
    Title^fontSize #= 20,
    Title^fontStyle #= bold,

    cgLabel(SubTitle,"Neng-Fa Zhou (CUNY)"),
    SubTitle^fontSize #= 16,
    SubTitle^fontStyle #= bold,
    SubTitle^color #= blue,

    cgSetAlignment([Title,SubTitle],center),

    cgRectangle([LeftP,RightP,CenterP]),
    LeftP^width #= RightP^width, LeftP^width#= 200,
    CenterP^width #= 400, CenterP^height #= 560,
    
    cgSame([Title,SubTitle,CenterP],centerX),

    cgTable([[Title,Title,Title],
	     [SubTitle,SubTitle,SubTitle],
	     [LeftP,CenterP,RightP]],5,10),
    
    MainComps=[Title,SubTitle,LeftP,RightP,CenterP],
    cgSame(MainComps,window,Win),
    cgPack(MainComps),
    cgShow([Title,SubTitle]),

% fill each of the panels
    leftPan(LeftP,Win),
    centerPan(CenterP,Win),
    rightPan(RightP,Win).

leftPan(LeftP,Win):-
    Frames=[AusFrame,AntiguaFrame,QueenFrame,HanoiFrame],
    cgRectangle(Frames),
    cgSame(Frames,window,Win),
    cgInside(Frames,LeftP),
    AusFrame^width #>= 130,
    cgGrid([[AusFrame],
	    [AntiguaFrame],
	    [QueenFrame],
	    [HanoiFrame]],10,10),
    AusFrame^rightX #= LeftP^rightX,
    cgPack(Frames),

    fill_aus(AusFrame,Win),
    fill_antigua(AntiguaFrame,Win),
    fill_queen(QueenFrame,Win),
    fill_hanoi(HanoiFrame,Win).

rightPan(RightP,Win):-
    Frames=[CalFrame,GoFrame,ChessFrame,KnighttourFrame],
    cgRectangle(Frames),
    cgSame(Frames,window,Win),
    cgInside(Frames,RightP),
    CalFrame^width #>= 130,
    cgGrid([[CalFrame],
	    [GoFrame],
	    [ChessFrame],
	    [KnighttourFrame]],10,10),
    cgPack(Frames),
    
    fill_cal(CalFrame,Win),
    fill_go(GoFrame,Win),
    fill_chess(ChessFrame,Win),
    fill_knight(KnighttourFrame,Win).    

centerPan(CenterP,Win):-
    cgTextArea(Des),
    cgSame([CenterP,Des],size),
    Des^window #= Win,
    Des^fontSize #= 14,
    Des^fontName #= "TimesRoman",
    cgInside(Des,CenterP),
    cgSetText(Des,
"   CGLIB is a constraint-based high-level graphics library 
developed for B-Prolog. It supports over twenty types of basic 
graphical objects and provides a set of constraints including 
non-overlap, grid, table, and tree constraints that facilitates 
the specification of layouts of objects. The constraint solver 
of B-Prolog serves as a general-purpose and efficient layout 
manager, which is significantly more flexible than the 
special-purpose layout managers used in Java. The library adopts 
a construct called action rules available in B-Prolog for 
creating agents and programming interactions among agents or 
between agents and users.

Here is an illustrative example:
      go:-
          cgButton(B,""Hello World""),
          handleButtonClick(B),
          cgShow(B).
      handleButtonClick(B),
          {actionPerformed(B)}
          =>
          halt.
The call cgButton(B) creates a button B with the text ""Hello
World"". The call handleButtonClick(B) is an event handler, which
will be activated when the button B is clicked. The call
cgShow(B) packs and shows the button.

CGLIB can be used in many areas such as drawing editors, 
interactive user interfaces, document authoring, animation, 
information visualization, intelligent agents, and games.

References:
1. CGLIB - A Constraint-based Graphics Library, Software - 
   Practice and Experience, Vol.33, No.13, pp.1199-1216, 2003.

2. B-Prolog: www.probp.com"),
               
    cgShow(Des).

:-include('australia').
fill_aus(Frame,Win):-
    two_thirds_frame_h(Frame,Win,NewFrame),
    australia(Comps,Win),
    pack_resize_show(Comps,NewFrame).

:-include('antiguabarbuda').
fill_antigua(Frame,Win):-
    two_thirds_frame_h(Frame,Win,NewFrame),
    antiguabarbuda(Comps,Win),
    pack_resize_show(Comps,NewFrame).

:-include(queens).
fill_queen(Frame,Win):-
    solveAndCreateQueens(50,Comps,0),
    cgSame(Comps,window,Win),
    pack_resize_show(Comps,Frame).
    
:-include(hanoi).
hanoi(N,Comps,Win):-
    createControlPanel(N,200,Win,CP,_),
    HanoiWorld=hanoi(N,Disks,Poles,Table),
    createHanoiWorld(HanoiWorld,CP),
    Poles=poles(pole(P1,_),pole(P2,_),pole(P3,_)),
    array_to_list(Disks,DisksList),
    Comps=[Table,P1,P2,P3|DisksList],
    cgSame(Comps,window,Win).

fill_hanoi(Frame,Win):-
    hanoi(5,Comps,Win),
    pack_resize_show(Comps,Frame).

:-include(calculator).
fill_cal(Frame,Win):-
    calculator(_,Comps),
    two_thirds_frame_v(Frame,Win,NewFrame),
    cgSame(Comps,window,Win),
    pack_resize_show(Comps,NewFrame).

:-include(igo).
fill_go(Frame,Win):-
    goBoard(9,Win,Comps),
    cgSame(Comps,window,Win),
    pack_resize_show(Comps,Frame).

:-include(chess).
fill_chess(Frame,Win):-
    chessBoard(Win,Comps),
    cgSame(Comps,window,Win),
    pack_resize_show(Comps,Frame).
    

:-include(knighttour).
fill_knight(Frame,Win):-
    knight_tour(Win,Comps),
    pack_resize_show(Comps,Frame).    


two_thirds_frame_h(Frame,Win,NewFrame):-
    cgRectangle(NewFrame),
    NewFrame^width #= Frame^width,
    NewFrame^height #= Frame^height*2//3,
    NewFrame^x #= Frame^x,
    NewFrame^y #= Frame^y+Frame^width//6,
    NewFrame^window #= Frame^window,
    cgPack(NewFrame).

two_thirds_frame_v(Frame,Win,NewFrame):-
    cgRectangle(NewFrame),
    NewFrame^height #= Frame^height,
    NewFrame^width #= Frame^width*2//3,
    NewFrame^y #= Frame^y,
    NewFrame^x #= Frame^x+Frame^width//6,
    NewFrame^window #= Frame^window,
    cgPack(NewFrame).

pack_resize_show(Comps,Frame):-
    cgPack(Comps),
    Frame^width #= W,
    Frame^height #= H,
    cgResize(Comps,W,H),
    Frame^x #= X,
    Frame^y #= Y,
    cgMove(Comps,X,Y),
    cgShow(Comps).


