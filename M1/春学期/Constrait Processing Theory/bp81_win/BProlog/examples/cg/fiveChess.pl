% Five Chess 
% Black : 1, White : 2

go :-
	global_set(black,0,0),
	global_set(white,0,0),
	fiveChess.

fiveChess:-
	cgWindow(W,"Five Chess"),
	W^topMargin #= 25, W^leftMargin #= 25,
    	W^width #= 800, W^height #= 600,
	cgSquare(Square), Square^color #= orange,
	Square^width #= 500,
	Square^x #= 25, Square^y #= 75,
	drawBoard(16,Comps,[]),
    	cgSame([Square|Comps],window,W),
    	cgShow([Square|Comps]),
	handleWindowClosing(W),
	showLabel(W),
	
	cgButton(R,"reset"),
    	R^x #= 600, R^y #= 300,
    	R^width #= 100, R^height #= 50,
	R^window #= W, 
	cgShow(R),
    	handleButtonResetClick(W,R),

	cgButton(U,"undo"),
    	U^x #= 600, U^y #= 200,
    	U^width #= 100, U^height #= 50,
	U^window #= W, 
	cgShow(U),
    	handleButtonUndoClick(W,U),

	init(C),
	global_set(state,0,0),
	global_set(player,0,1),
	global_set(board,0,C),
	global_set(last,0,[]),
	handleMousePress(W).	

handleWindowClosing(Win),{windowClosing(Win)} => abort.

handleButtonResetClick(W,R),{actionPerformed(R)} => cgClose(W),	fiveChess.

handleButtonUndoClick(W,U),{actionPerformed(U)} => buttonUndoClicked(W).

buttonUndoClicked(W):-
	global_get(state,0,0),
	global_get(last,0,Js), Js \== [], !,
	append(J1,[J],Js),
	global_get(board,0,C),
	global_get(player,0,N),
	change(J,0,C,C1), put(J,0,W),
	(N == 1 -> N1 = 2; N1 = 1),
	global_set(player,0,N1), 
	global_set(board,0,C1), 
	global_set(last,0,J1).
buttonUndoClicked(W).

handleMousePress(W),{mousePressed(W,E)}=>
	E^x #= X, E^y #= Y,
	(handleMousePressed(W,X,Y);true).

handleMousePressed(W,X,Y):-
	global_get(state,0,0),
	global_get(player,0,N),
	global_get(board,0,C),
	X > 35, X < 515,
	Y > 85, Y < 565,
	J is (Y-85)//30*16+(X-35)//30+1,
	change(J,N,C,C1),
	put(J,N,W),
	count(W,N,J,C),
	(N == 1 -> N1 = 2; N1 = 1),
	global_get(last,0,Js),
	append(Js,[J],J1),
	global_set(last,0,J1),
	global_set(player,0,N1),
	global_set(board,0,C1).

drawBoard(N,Comps,CompsR):-
	drawHorizontalLines(0,N,Comps,Comps1),
    	drawVerticalLines(0,N,Comps1,CompsR).

drawHorizontalLines(I,N,Comps,CompsR):-I>N,!,Comps=CompsR.
drawHorizontalLines(I,N,Comps,CompsR):-
    	cgLine(Line),
	LM #= 35, TM #= 85,
    	Line^x1 #= LM, Line^y1 #= 30*I+TM,
    	Line^x2 #= 30*N+LM, Line^y2 #= Line^y1,
    	Comps=[Line|Comps1],
    	I1 is I+1,
    	drawHorizontalLines(I1,N,Comps1,CompsR).

drawVerticalLines(I,N,Comps,CompsR):-I>N,!,Comps=CompsR.
drawVerticalLines(I,N,Comps,CompsR):-
    	cgLine(Line),
    	LM #= 35, TM #= 85,
    	Line^x1 #= 30*I+LM, Line^y1 #= TM,
    	Line^x2 #= Line^x1, Line^y2 #= N*30+TM,
    	Comps=[Line|Comps1],
    	I1 is I+1,
    	drawVerticalLines(I1,N,Comps1,CompsR).
	
put(J,N,W) :-
	X is (J - 1) mod 16 + 1, Y is (J - 1) // 16 + 1,
	color(N,C), 
	cgCircle(S),
	S^window #= W,
    	S^centerX #= X*30+35-15,
    	S^centerY #= Y*30+85-15,
    	S^diameter #= 25,
    	S^color #= C,
	cgShow(S).

color(0,orange).
color(1,black).
color(2,white).

init(C):- init(C,256).
init([],0).
init([0|C],N):-	N1 is N-1, init(C,N1).

change(1,E,[X|T],[E|T]) :- (E \== 0->X == 0; E == 0), !.
change(N,E,[H|T],[H|X]) :- N > 1, N1 is N - 1, change(N1,E,T,X).

get(1,H,[H|_]).
get(N,X,[_|T]):- N>1, N1 is N-1, get(N1,X,T).

count(W,N,J,C):- 
	count1(N,J,C,5)->writeln(1),final(N,W);
	count2(N,J,C,5)->writeln(2),final(N,W);
	count3(N,J,C,5)->writeln(3),final(N,W);
	count4(N,J,C,5)->writeln(4),final(N,W);true.

count1(N,J,C,Count):-
	J1 is J-1, J2 is J+1,
	west(N,J1,C,Count1),
	east(N,J2,C,Count2),
	Count is 1+Count1+Count2.
count2(N,J,C,Count):-
	J1 is J+15, J2 is J-15,
	south_west(N,J1,C,Count1),
	north_east(N,J2,C,Count2),
	Count is 1+Count1+Count2.
count3(N,J,C,Count):-
	J1 is J-17, J2 is J+17,
	north_west(N,J1,C,Count1),
	south_east(N,J2,C,Count2),
	Count is 1+Count1+Count2.
count4(N,J,C,Count):-
 	J1 is J-16, J2 is J+16,
	north(N,J1,C,Count1),
	south(N,J2,C,Count2),
	Count is 1+Count1+Count2.
	
west(N,J,C,Count):-	
	J>0, J1 is J mod 16,J1 \== 0,
	get(J,X,C), X == N,!,
	J2 is J-1, west(N,J2,C,Count1), Count is 1+Count1.
west(N,J,C,0).

east(N,J,C,Count):-
	J<257, J1 is J mod 16, J1 \== 1,
	get(J,X,C), X == N,!,
	J2 is J+1, east(N,J2,C,Count1), Count is 1+Count1.
east(N,J,C,0).

south_west(N,J,C,Count):- 
	J<257, J1 is J mod 16, J1 \== 0,
	get(J,X,C), X == N,!,
	J2 is J+15, south_west(N,J2,C,Count1), Count is 1+Count1.
south_west(N,J,C,0).

north_east(N,J,C,Count):- 
	J>0, J1 is J mod 16, J1 \== 1,
	get(J,X,C), X == N,!,
	J2 is J-15, north_east(N,J2,C,Count1), Count is 1+Count1.
north_east(N,J,C,0).

north_west(N,J,C,Count):- 
	J>0, J1 is J mod 16, J1 \== 0,
	get(J,X,C), X == N,!,
	J2 is J-17, north_west(N,J2,C,Count1), Count is 1+Count1.
north_west(N,J,C,0).

south_east(N,J,C,Count):- 
	J<257, J1 is J mod 16, J1 == 1,
	get(J,X,C), X == N, !,
	J2 is J+17, south_east(N,J2,C,Count1), Count is 1+Count1.
south_east(N,J,C,0).

north(N,J,C,Count):-
	J>0, get(J,X,C), X==N, !,
	J1 is J-16, north(N,J1,C,Count1), Count is 1+Count1.
north(N,J,C,0).

south(N,J,C,Count):-
	J<257, get(J,X,C), X==N, !,
	J1 is J+16, south(N,J1,C,Count1), Count is 1+Count1.
south(N,J,C,0).
	
final(N,W):- massage(N,W), showLabel(W), global_set(state,0,1).
 	
massage(N,W):-
	text(N,Text),
	cgLabel(Label,Text),
	Label^fontStyle #= 'bold',
	Label^fontSize #= 20,
	Label^window #= W,
	Label^color #= red,
	cgShow(Label).

text(1,Text):-
	Text = "Black is the winner!!",
	global_get(black,0,N),
	N1 is N+1,
	global_set(black,0,N1).
text(2,Text):-
	Text = "White is the winner!!",
	global_get(white,0,N),
	N1 is N+1,
	global_set(white,0,N1).	

showLabel(W):-
	global_get(black,0,CountB),
	global_get(white,0,CountW),
	number_codes(CountB,CodeB),
	number_codes(CountW,CodeW),
	append("Black : White = ",CodeB,Text1),
	append(Text1," : ",Text2),
	append(Text2,CodeW,Text),
	cgLabel(Label,Text),
	cgRectangle(R), R^color #= white,
	R^x #= 600, R^y #= 100,
	R^height #= 100, R^width #= 200,
	R^window #= W, 
	Label^fontSize #= 12, Label^fontStyle #= 'bold',
	Label^window #= W,
	cgInside(Label,R),
	cgShow([R,Label]).
