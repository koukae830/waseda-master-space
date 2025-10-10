/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    solve eight-puzzle problems
*********************************************************************/
go:-
    cgWindow(Win,"eightPuzzle"),Win^topMargin#=30, Win^leftMargin #= 20,
    handleWindowClosing(Win),
    puzzle(Os,Win),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

puzzle(Comps,Win):-
    initState(S,Ssquares),
    finalState(G,Gsquares),
    % place the boards
    cgLabel(Lcurr,"Current"),
    cgLabel(Lgoal,"Goal"),
    cgRectangle([Box1,Box2]),
    cgTable([[Lcurr,Lgoal],[Box1,Box2]],2,2),
    cgInside(Ssquares,Box1), Box1^width #= 200, Box1^height #= 200,
    cgInside(Gsquares,Box2), Box2^width #= 200, Box2^height #= 200,
    %
    handleAction(S,G,1,3),
    cgSame([Lcurr,Lgoal,Box1,Box2],window,Win),
    cgPack([Lcurr,Lgoal,Box1,Box2]),
    append([Lcurr,Lgoal|Ssquares],Gsquares,Comps).

initState(State,Buttons):-
    State=state(board(row(B1,B3,B0),
		      row(B8,B2,B4),
		      row(B7,B6,B5)),
		1,3),
    Buttons=[B0,B1,B2,B3,B4,B5,B6,B7,B8],
    cgButton(Buttons,[" ","1","2","3","4","5","6","7","8"]),
    B0^width #= 40,
    cgSame(Buttons,fontSize,36),
    cgGrid([[B1,B3,B0],
	    [B8,B2,B4],
	    [B7,B6,B5]],2,2).

finalState(State,Buttons):-
    State=state(board(row(B1,B2,B3),
		      row(B8,B0,B4),
		      row(B7,B6,B5)),
		2,2),
    Buttons=[B0,B1,B2,B3,B4,B5,B6,B7,B8],
    cgButton(Buttons,[" ","1","2","3","4","5","6","7","8"]),
    B0^width #= 40,
    cgSame(Buttons,fontSize,36),
    cgGrid([[B1,B2,B3],
	    [B8,B0,B4],
	    [B7,B6,B5]],2,2).

handleAction(State,Goal,X0,Y0):-
    State=state(board(row(B11,B12,B13),
		  row(B21,B22,B23),
		  row(B31,B32,B33)),
	    X0,Y0),
    handleAction(B11,State,Goal,1,1),
    handleAction(B12,State,Goal,1,2),
    handleAction(B13,State,Goal,1,3),
    handleAction(B21,State,Goal,2,1),
    handleAction(B22,State,Goal,2,2),
    handleAction(B23,State,Goal,2,3),
    handleAction(B31,State,Goal,3,1),
    handleAction(B32,State,Goal,3,2),
    handleAction(B33,State,Goal,3,3).

handleAction(B,State,Goal,X,Y),{actionPerformed(B)} =>
    move(B,State,Goal,X,Y).

move(_B,Curr,Goal,_X,_Y):-
    Curr=state(Cboard,X0,Y0),
    Goal=state(Gboard,X0,Y0),
    Cboard=board(row(C1,C2,C3),
		 row(C4,C5,C6),
		 row(C7,C8,C9)),
    Gboard=board(row(G1,G2,G3),
		 row(G4,G5,G6),
		 row(G7,G8,G9)),
    match([C1,C2,C3,C4,C5,C6,C7,C8,C9],[G1,G2,G3,G4,G5,G6,G7,G8,G9]),!.
move(B,Curr,_Goal,X,Y):-
    Curr=state(Board,X0,Y0),
    neighbors(X0,Y0,X,Y),!,
    %update texts on buttons
    cgGetText(B,Text),
    cgSetText(B," "),
    arg(X0,Board,Row0),
    arg(Y0,Row0,B0),
    cgSetText(B0,Text),
    % (X,Y) becomes the empty square
    setarg(2,Curr,X),
    setarg(3,Curr,Y),
    cgShow([B0,B]).
move(_B,_Curr,_Goal,_X,_Y).

match([],[]).
match([C|Cs],[G|Gs]):-
    cgGetText(C,Text),
    cgGetText(G,Text),
    match(Cs,Gs).

neighbors(X0,Y0,X,Y):-
    X0=:=X,
    (Y=:=Y0+1;Y=:=Y0-1).
neighbors(X0,Y0,X,Y):-
    Y0=:=Y,
    (X=:=X0+1;X=:=X0-1).

