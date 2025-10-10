main:-
  go,
  $event_watching_loop.

go:-
	cgWindow(Win,"Chess"), 
	Win^width #= 800, Win^height #= 600,
	Win^topMargin #= 50, Win^leftMargin #= 50,
	handleWindowClose(Win),

	cgButton(R,"reset"),
    	R^x #= 600, R^y #= 100,
    	R^width #= 100, R^height #= 50,
	R^window #= Win, 
	cgShow(R),
    	handleButtonResetClick(Win,R),

	drawChessBoard(Win,Area,Board,_),
	putPieces(Win,BPieces,WPieces,Board),
	global_set(state,0,0),
	global_set(state,1,1),
	handleMousePress(Win,Area,BPieces,WPieces,Board),
	handleMouseRelease(Win,Area,BPieces,WPieces,Board).


chessBoard(Win,Comps):-
    drawChessBoard(Win,Area,Board,Squares),
    putPieces(Win,BPieces,WPieces,Board),
    append(Squares,BPieces,Comps1),
    append(Comps1,WPieces,Comps).

handleWindowClose(Win),{windowClosing(Win)} => abort.

handleButtonResetClick(Win,R),{actionPerformed(R)} => cgClose(Win), go.

handleMousePress(Win,Area,BPieces,WPieces,Board),{mousePressed(Win,E)}=>
	E^x #= X, E^y #= Y, inside(X,Y,Area),
	global_set(x,0,X), global_set(y,0,Y);true.

handleMouseRelease(Win,Area,BPieces,WPieces,Board),{mouseReleased(Win,E)}=>
	E^x #= X, E^y #= Y, inside(X,Y,Area),
	global_get(x,0,X0), global_get(y,0,Y0),
	handleAction(X0,Y0,X,Y,Win,Area,BPieces,WPieces,Board),
	global_del(x,0), global_del(y,0);true.

handleAction(X0,Y0,X,Y,Win,Area,BPieces,WPieces,Board):-
	global_get(state,0,0),
	global_get(state,1,1),
	insideList(X0,Y0,WPieces,P),
	insideList(X,Y,Board,S),
	move(P,S,WPieces,BPieces,Board,Win),
	global_set(state,1,0).
handleAction(X0,Y0,X,Y,Win,Area,BPieces,WPieces,Board):-
	global_get(state,0,0),
	global_get(state,1,0),
	insideList(X0,Y0,BPieces,P),
	insideList(X,Y,Board,S),
	move(P,S,BPieces,WPieces,Board,Win),
	global_set(state,1,1).

move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, king(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY, 
	X2 > X1-75, X2 < X1+75,
	Y2 > Y1-75, Y2 < Y1+75,
	not(insideList(X2,Y2,Pieces,_)),
	P^x #:= S^x+10, P^y #:= S^y+10,
	(insideList(X2,Y2,Enemy,Killed)->del(Killed),check(Killed,Win);true),
	cgShow(P).
move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, queen(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY,
	(X1==X2, Y1<Y2->south(X1,X2,Y1,Y2,Pieces,Enemy); 
	 X1==X2, Y1>Y2->north(X1,X2,Y1,Y2,Pieces,Enemy);
	 X1<X2, Y1==Y2->east(X1,X2,Y1,Y2,Pieces,Enemy); 
	 X1>X2, Y1==Y2->west(X1,X2,Y1,Y2,Pieces,Enemy);
	 X1<X2, Y1<Y2, X3 is X2-X1, Y3 is Y2-Y1, X3==Y3->south_east(X1,X2,Y1,Y2,Pieces,Enemy); 
	 X1>X2, Y1<Y2, X3 is X1-X2, Y3 is Y2-Y1, X3==Y3->south_west(X1,X2,Y1,Y2,Pieces,Enemy);
	 X1<X2, Y1>Y2, X3 is X2-X1, Y3 is Y1-Y2, X3==Y3->north_east(X1,X2,Y1,Y2,Pieces,Enemy); 
	 X1>X2, Y1>Y2, X3 is X1-X2, Y3 is Y1-Y2, X3==Y3->north_west(X1,X2,Y1,Y2,Pieces,Enemy)),
	not(insideList(X2,Y2,Pieces,_)),
	P^x #:= S^x+10, P^y #:= S^y+10,
	(insideList(X2,Y2,Enemy,Killed)->del(Killed),check(Killed,Win);true),
	cgShow(P).
move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, bishop(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY, 
	(X1<X2, Y1<Y2, X3 is X2-X1, Y3 is Y2-Y1, X3==Y3->south_east(X1,X2,Y1,Y2,Pieces,Enemy); 
	 X1>X2, Y1<Y2, X3 is X1-X2, Y3 is Y2-Y1, X3==Y3->south_west(X1,X2,Y1,Y2,Pieces,Enemy);
	 X1<X2, Y1>Y2, X3 is X2-X1, Y3 is Y1-Y2, X3==Y3->north_east(X1,X2,Y1,Y2,Pieces,Enemy); 
	 X1>X2, Y1>Y2, X3 is X1-X2, Y3 is Y1-Y2, X3==Y3->north_west(X1,X2,Y1,Y2,Pieces,Enemy)),
	not(insideList(X2,Y2,Pieces,_)),
	P^x #:= S^x+10, P^y #:= S^y+10,
	(insideList(X2,Y2,Enemy,Killed)->del(Killed),check(Killed,Win);true),
	cgShow(P).
move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, knight(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY,
	X3 is abs(X1-X2), Y3 is abs(Y1-Y2),
	(X3 == 100, Y3 == 50; X3 == 50, Y3 == 100),
	not(insideList(X2,Y2,Pieces,_)),
	P^x #:= S^x+10, P^y #:= S^y+10,
	(insideList(X2,Y2,Enemy,Killed)->del(Killed),check(Killed,Win);true),
	cgShow(P).
move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, rook(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY,
	(X1==X2, Y1<Y2->south(X1,X2,Y1,Y2,Pieces,Enemy); 
	 X1==X2, Y1>Y2->north(X1,X2,Y1,Y2,Pieces,Enemy);
	 X1<X2, Y1==Y2->east(X1,X2,Y1,Y2,Pieces,Enemy); 
	 X1>X2, Y1==Y2->west(X1,X2,Y1,Y2,Pieces,Enemy)),
	not(insideList(X2,Y2,Pieces,_)),
	P^x #:= S^x+10, P^y #:= S^y+10,
	(insideList(X2,Y2,Enemy,Killed)->del(Killed),check(Killed,Win);true),
	cgShow(P).
move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, wpawn(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY,
	X1 == X2, Y3 is Y1-Y2,
	(Y1 == 425->(Y3 == 100; Y3 == 50); Y3 == 50),
	not(insideList(X2,Y2,Pieces,_)),
	not(insideList(X2,Y2,Enemy,_)),
	P^x #:= S^x+10, P^y #:= S^y+10,
	(insideList(X2,Y2,Enemy,Killed)->del(Killed),check(Killed,Win);true),
	cgShow(P),(Y2==125->exchange(Win,P);true).
move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, wpawn(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY,
	X3 is abs(X1-X2), Y3 is Y1-Y2,
	X3 == 50, Y3 == 50,
	not(insideList(X2,Y2,Pieces,_)),
	insideList(X2,Y2,Enemy,Killed),
	P^x #:= S^x+10, P^y #:= S^y+10,
	del(Killed),check(Killed,Win),
	cgShow(P),(Y2==125->exchange(Win,P);true).
move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, bpawn(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY,
	X1 == X2, Y3 is Y2-Y1,
	(Y1 == 175-> (Y3 == 50;Y3 == 100); Y3 == 50),
	not(insideList(X2,Y2,Pieces,_)),
	not(insideList(X2,Y2,Enemy,_)),
	P^x #:= S^x+10, P^y #:= S^y+10,
	(insideList(X2,Y2,Enemy,Killed)->del(Killed),check(Killed,Win);true),
	cgShow(P),(Y2==475->exchange(Win,P);true).
move(P,S,Pieces,Enemy,Board,Win):-
	P^name #= Name, bpawn(Name),
	X1 #= P^centerX, Y1 #= P^centerY,
	X2 #= S^centerX, Y2 #= S^centerY,
	X3 is abs(X1-X2), Y3 is Y2-Y1,
	X3 == 50, Y3 == 50,
	not(insideList(X2,Y2,Pieces,_)),
	insideList(X2,Y2,Enemy,Killed),
	P^x #:= S^x+10, P^y #:= S^y+10,
	(Y2==475->exchange(Win,P);true),
	del(Killed),check(Killed,Win),
	cgShow(P),(Y2==475->exchange(Win,P);true).

exchange(Win,P):-
	P^name #= Name, wpawn(Name),
	cgLabel(Label,"Please choose one "),
	Label^fontStyle #= 'bold', Label^fontSize #= 20,
	Images = [Image1,Image2,Image3,Image4],
	cgImage(Images),
	Image1^name #= "wqueen.jpg",
	Image2^name #= "wbishop.jpg",
	Image3^name #= "wknight.jpg",
	Image4^name #= "wrook.jpg",
	cgTable([[Label|Images]]), Label^y #= 550,
	cgSame([Label|Images],window,Win),
	cgSame(Images,width,30),cgSame([Label|Images],height,30),
	cgShow([Label|Images]),
	handleMousePress(Win,Label,Images,P).
exchange(Win,P):-
	P^name #= Name, bpawn(Name),
	cgLabel(Label,"Please choose one "),
	Label^fontStyle #= 'bold', Label^fontSize #= 20,
	Images = [Image1,Image2,Image3,Image4],
	cgImage(Images),
	Image1^name #= "bqueen.jpg",
	Image2^name #= "bbishop.jpg",
	Image3^name #= "bknight.jpg",
	Image4^name #= "brook.jpg",
	cgTable([[Label|Images]]), Label^y #= 550,
	cgSame([Label|Images],window,Win),
	cgSame(Images,width,30),cgSame([Label|Images],height,30),
	cgShow([Label|Images]),
	handleMousePress(Win,Label,Images,P).

handleMousePress(Win,Label,Images,P),{mousePressed(Win,E)}=>
	E^x #= X, E^y #= Y,
	(insideList(X,Y,Images,Image),global_set(state,0,0),P^name #:= Image^name,cgShow(P),cgClean([Label|Images]);true).
	
del(Killed):-
	cgClean(Killed),
	Killed^x #:= 600, Killed^y #:= 50.

check(Killed,Win):-
	Killed^name #= Name, king(Name),!,
	(global_get(state,1,1)->cgLabel(Label,"White is the winner!");
	 cgLabel(Label,"Black is the winner!")),
	Label^window #= Win, Label^y #= 550,
	Label^fontStyle #= 'bold', Label^fontSize #= 20, cgShow(Label), 
	global_set(state,0,1).
check(Killed,Win).

south(X1,X2,Y1,Y2,Pieces,Enemy):-Y3 is Y1+50, Y3 == Y2.
south(X1,X2,Y1,Y2,Pieces,Enemy):-
	Y3 is Y1+50,
	not(insideList(X1,Y3,Pieces,_)),
	not(insideList(X1,Y3,Enemy,_)),
	south(X1,X2,Y3,Y2,Pieces,Enemy).

north(X1,X2,Y1,Y2,Pieces,Enemy):-Y3 is Y1-50, Y3==Y2.
north(X1,X2,Y1,Y2,Pieces,Enemy):-
	Y3 is Y1-50,
	not(insideList(X1,Y3,Pieces,_)),
	not(insideList(X1,Y3,Enemy,_)),
	north(X1,X2,Y3,Y2,Pieces,Enemy).

east(X1,X2,Y1,Y2,Pieces,Enemy):-X3 is X1+50, X3==X2.
east(X1,X2,Y1,Y2,Pieces,Enemy):-
	X3 is X1+50,
	not(insideList(X3,Y1,Pieces,_)),
	not(insideList(X3,Y1,Enemy,_)),
	east(X3,X2,Y1,Y2,Pieces,Enemy).

west(X1,X2,Y1,Y2,Pieces,Enemy):-X3 is X1-50, X3==X2.
west(X1,X2,Y1,Y2,Pieces,Enemy):-
	X3 is X1-50,
	not(insideList(X3,Y1,Pieces,_)),
	not(insideList(X3,Y1,Enemy,_)),
	west(X3,X2,Y1,Y2,Pieces,Enemy).

south_east(X1,X2,Y1,Y2,Pieces,Enemy):-X3 is X1+50, Y3 is Y1+50, X3==X2,Y3==Y2.
south_east(X1,X2,Y1,Y2,Pieces,Enemy):-
	X3 is X1+50, Y3 is Y1+50,
	not(insideList(X3,Y3,Pieces,_)),
	not(insideList(X3,Y3,Enemy,_)),
	south_east(X3,X2,Y3,Y2,Pieces,Enemy).

south_west(X1,X2,Y1,Y2,Pieces,Enemy):-X3 is X1-50, Y3 is Y1+50, X3==X2,Y3==Y2.
south_west(X1,X2,Y1,Y2,Pieces,Enemy):-
	X3 is X1-50, Y3 is Y1+50,
	not(insideList(X3,Y3,Pieces,_)),
	not(insideList(X3,Y3,Enemy,_)),
	south_west(X3,X2,Y3,Y2,Pieces,Enemy).

north_east(X1,X2,Y1,Y2,Pieces,Enemy):-X3 is X1+50, Y3 is Y1-50, X3==X2,Y3==Y2.
north_east(X1,X2,Y1,Y2,Pieces,Enemy):-
	X3 is X1+50, Y3 is Y1-50,
	not(insideList(X3,Y3,Pieces,_)),
	not(insideList(X3,Y3,Enemy,_)),
	north_east(X3,X2,Y3,Y2,Pieces,Enemy).

north_west(X1,X2,Y1,Y2,Pieces,Enemy):-X3 is X1-50, Y3 is Y1-50,X3==X2,Y3==Y2.
north_west(X1,X2,Y1,Y2,Pieces,Enemy):-
	X3 is X1-50, Y3 is Y1-50,
	not(insideList(X3,Y3,Pieces,_)),
	not(insideList(X3,Y3,Enemy,_)),
	north_west(X3,X2,Y3,Y2,Pieces,Enemy).

insideList(X,Y,[H|_],H):-inside(X,Y,H).
insideList(X,Y,[_|T],P):-insideList(X,Y,T,P).

inside(X,Y,S):-
	S^x #= MinX, S^y #= MinY,
	S^width #= W, S^height #= H,
	X >= MinX, X =< MinX+W,
	Y >= MinY, Y =< MinY+H.
	
drawChessBoard(Win,BoardSquare,SmallSquares,Squares):-
	Squares = [GreenSquare,WhiteSquare,BoardSquare|SmallSquares],
	cgSquare(GreenSquare), GreenSquare^color #= green,
	GreenSquare^width #= 500,
	cgSquare(WhiteSquare), WhiteSquare^color #= white,
	WhiteSquare^width #= 450,
	cgSquare(BoardSquare), BoardSquare^fill #= 0,
	BoardSquare^width #= 400,
	smallSquares(SmallSquares),
	cgSame(SmallSquares,width,50),
	cgSame([GreenSquare,WhiteSquare,BoardSquare],center),  
	cgInside(SmallSquares,BoardSquare),
	cgSame(Squares,window,Win),
	cgShow(Squares).

smallSquares(SmallSquares):-
	Lines = [L1,L2,L3,L4,L5,L6,L7,L8],
	createLines(Lines),
	cgGrid([L1,L2,L3,L4,L5,L6,L7,L8]),
	append(L1,L2,O1),
	append(L3,L4,O2),
	append(L5,L6,O3),
	append(L7,L8,O4),
	append(O1,O2,O5),
	append(O3,O4,O6),
	append(O5,O6,SmallSquares).

createLines([]).
createLines([L1,L2|Lines]):-
	L1 = [S11,S12,S13,S14,S15,S16,S17,S18],
	L2 = [S21,S22,S23,S24,S25,S26,S27,S28],
	createLine(1,L1),
	createLine(2,L2),
	cgGrid([L1]),
	cgGrid([L2]),
	createLines(Lines).

createLine(_,[]).
createLine(1,[W,G|Squares]):-
	cgSquare(W), W^fill #= 0,
	cgSquare(G), G^color #= green,
	createLine(1,Squares).
createLine(2,[G,W|Squares]):-
	cgSquare(G), G^color #= green,
	cgSquare(W), W^fill #= 0,
	createLine(2,Squares).

putPieces(Win,BPieces,WPieces,Board):-
	BPieces = [BR1,BK1,BB1,BQ,BK,BB2,BK2,BR2,BP1,BP2,BP3,BP4,BP5,BP6,BP7,BP8],
	WPieces = [WP1,WP2,WP3,WP4,WP5,WP6,WP7,WP8,WR1,WK1,WB1,WQ,WK,WB2,WK2,WR2],
	append(BPieces,WPieces,Pieces),

	cgImage(BPieces),
	BR1^name #= "brook.jpg",
	BK1^name #= "bknight.jpg",
	BB1^name #= "bbishop.jpg",
	BQ^name #= "bqueen.jpg",
	BK^name #= "bking.jpg",
	BB2^name #= "bbishop.jpg",
	BK2^name #= "bknight.jpg",
	BR2^name #= "brook.jpg",
	cgSame([BP1,BP2,BP3,BP4,BP5,BP6,BP7,BP8],name,"bpawn.jpg"),
	setPos(1,Board,BPieces),
	
	cgImage(WPieces),
	cgSame([WP1,WP2,WP3,WP4,WP5,WP6,WP7,WP8],name,"wpawn.jpg"),
	WR1^name #= "wrook.jpg",
	WK1^name #= "wknight.jpg",
	WB1^name #= "wbishop.jpg",
	WQ^name #= "wqueen.jpg",
	WK^name #= "wking.jpg",
	WB2^name #= "wbishop.jpg",
	WK2^name #= "wknight.jpg",
	WR2^name #= "wrook.jpg",
	setPos(49,Board,WPieces),

	cgSame(Pieces,width,30), cgSame(Pieces,height,30),
	cgSame(Pieces,window,Win), cgShow(Pieces).

get(1,[Square|_],Square):-!.
get(N,[_|Board],Square):- N>1, N1 is N-1, get(N1,Board,Square).

setPos(_,_,[]).
setPos(N,Board,[H|T]):-
	get(N,Board,S),
	cgSame([H,S],center),
	N1 is N+1,
	setPos(N1,Board,T).

king("wking.jpg").	king("bking.jpg").
queen("wqueen.jpg").	queen("bqueen.jpg").
bishop("wbishop.jpg").	bishop("bbishop.jpg").
knight("wknight.jpg").	knight("bknight.jpg").
rook("wrook.jpg").	rook("brook.jpg").
wpawn("wpawn.jpg").	bpawn("bpawn.jpg").
