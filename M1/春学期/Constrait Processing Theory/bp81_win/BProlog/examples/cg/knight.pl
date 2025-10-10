/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    find tours for a knight, by Wenju Cheng
*********************************************************************/
go:-
	global_set(num,0),
    	cgWindow(W,"Knight by Wen-Ju Cheng"),
    	W^width #= 780, W^height #= 680,
    	cgButton(B,"go"),
    	B^x #= 630, B^y #= 200,
    	B^width #= 100, B^height #= 50,
    	handleButtonClick(W,B),
    	cgButton(R,"reset"),
    	R^x #= 630, R^y #= 400,
    	R^width #= 100, R^height #= 50,
    	drawBoard(8,Comps,[]),
        Os=[B,R|Comps],
    	cgSame(Os,window,W),
        handleButtonResetClick(W,R,Os),
        cgShow(Os),
    	getValue(W).


handleButtonClick(Win,B),{actionPerformed(B)} =>
	(global_get(num,2)->
	 global_get(pos,1,Y),
	 global_get(pos,2,X),
	 solve([(X,[],Cost)],[X],Y,Knights),
	 drawKnights(Win,[Y|Knights]);
	 true).

handleButtonResetClick(W,R,Os),{actionPerformed(R)} =>
    	cgClean(W),
        global_set(num,0),
    	cgShow(Os).

getValue(W):-
    	handleWindowClosing(W),
    	handleMouseEvent(W).
	
handleMouseEvent(W),{mousePressed(W,E)}=>
	E^x #= X, E^y #= Y,	
        global_get(num,N),
        mouseClicked(W,N,X,Y).

mouseClicked(Win,N,X,Y):-
	X > 100, X < 580,
	Y > 100, Y < 580,	
	Px is (X-100)//60+1,
	Py is (Y-100)//60+1,
	!,
        mouseClicked2(Win,N,Px,Py).
mouseClicked(Win,N,X,Y).

mouseClicked2(W,N,Px,Py):-
        N<2,!,
	N1 is N+1,
       	global_set(pos,N1,(Py,Px)),
	global_set(num,N1),
	cgCircle(S),S^window#=W,
    	S^centerX #= (Px-1)*60+100+30,
    	S^centerY #= (Py-1)*60+100+30,
    	S^diameter #= 50,
    	S^color #= red,
    	cgShow(S).
mouseClicked2(W,N,Px,Py).

solve(A1,A2,Y,Path):-
   solve1(A1,A2,Y,Path),!.


solve1([(Y,Path,Cost)|Open],Closed,Y,Path):-!.
solve1([(X,Path,Cost)|Open],Closed,Y,Path1):-
	next(X,Next), 
	delete(Next,Closed,New),
	append(New,Closed,Closed1),
	cost(Y,X,Path,New,New1),
	insert(New1,Open,Open1),	
	solve1(Open1,Closed1,Y,Path1).

next((I,J),[(I1,J1),(I2,J2),(I3,J3),(I4,J4),(I5,J5),(I6,J6),(I7,J7),(I8,J8)]):-
	I1 is I+1,J1 is J-2,I2 is I+1,J2 is J+2,I3 is I+2,J3 is J-1,
        I4 is I+2,J4 is J+1,I5 is I-1,J5 is J-2,I6 is I-1,J6 is J+2,
        I7 is I-2,J7 is J-1,I8 is I-2,J8 is J+1.

delete([],_,[]).
delete([(I,J)|Next],Closed,[(I,J)|New]):-
	I>0,J>0,I<9,J<9,not member((I,J),Closed),!,delete(Next,Closed,New).
delete([X|Next],Closed,New):-
	delete(Next,Closed,New).

cost(_,_,_,[],[]).
cost((I,J),X,Path,[(I1,J1)|New],[((I1,J1),Path1,Cost)|NewNode]):-
	DI is abs(I1-I),
	DJ is abs(J1-J),
	Path1 = [X|Path],
	length(Path1,N),
	Cost is DI+DJ+N,
	cost((I,J),X,Path,New,NewNode).

insert([],Open,Open).
insert([X|New],Open,Open1):-
	insert(New,Open,Open2),
	insert_X(X,Open2,Open1).

insert_X((X,Path,Cost),[(Y,YPath,YCost)|Open],[(Y,YPath,YCost)|Open1]):-
	Cost>YCost,!,insert_X((X,Path,Cost),Open,Open1).
insert_X(X,Y,[X|Y]).

drawKnights(Win,Knights):-
    	drawLine(Knights,Comps,Comps1),
    	drawKnights(Knights,Comps1,[]),!,
    	cgSame(Comps,window,Win),
    	cgShow(Comps).

drawBoard(N,Comps,CompsR):-
    	drawHorizontalLines(0,N,Comps,Comps1),
    	drawVerticalLines(0,N,Comps1,CompsR).

drawHorizontalLines(I,N,Comps,CompsR):-I>N,!,Comps=CompsR.
drawHorizontalLines(I,N,Comps,CompsR):-
    	cgLine(Line),
    	LM #= 100, TM #= 100,
    	Line^x1 #= LM, Line^y1 #= 60*I+TM,
    	Line^x2 #= 60*N+LM, Line^y2 #= Line^y1,
    	Comps=[Line|Comps1],
    	I1 is I+1,
    	drawHorizontalLines(I1,N,Comps1,CompsR).

drawVerticalLines(I,N,Comps,CompsR):-I>N,!,Comps=CompsR.
drawVerticalLines(I,N,Comps,CompsR):-
    	cgLine(Line),
    	LM #= 100, TM #= 100,
    	Line^x1 #= 60*I+LM, Line^y1 #= TM,
    	Line^x2 #= Line^x1, Line^y2 #= N*60+TM,
    	Comps=[Line|Comps1],
    	I1 is I+1,
    	drawVerticalLines(I1,N,Comps1,CompsR).
    
drawKnights([],Comps,CompsR):-Comps=CompsR.
drawKnights([(J,I)|Knights],Comps,CompsR):-
    	cgCircle(S),
    	LM #= 100, TM #= 100,    
    	S^centerX #= (I-1)*60+LM+30,
    	S^centerY #= (J-1)*60+TM+30,
    	S^diameter #= 50,
    	S^color #= red,
    	Comps=[S|Comps1],
    	drawKnights(Knights,Comps1,CompsR).

drawLine([_],Comps,CompsR):-Comps=CompsR.
drawLine([(J,I),(J1,I1)|Knights],Comps,CompsR):-
    	cgLine(Line),
	LM #= 100, TM #= 100,
    	Line^x1 #= (I-1)*60+LM+30, Line^y1 #= (J-1)*60+TM+30,
    	Line^x2 #= (I1-1)*60+LM+30, Line^y2 #= (J1-1)*60+TM+30,
    	Line^color #= red,
    	Comps=[Line|Comps1],
    	drawLine([(J1,I1)|Knights],Comps1,CompsR).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).
