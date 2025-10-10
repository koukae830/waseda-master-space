% An Othello playing Program 
% by Ito Ko, ko_ito@hp.com, ported to B-Prolog by Wenju Cheng
% Black : Human(1), White : Computer(2)

go :-
    cgWindow(W,"Othello Game"),
    W^width #= 780, W^height #= 680,
    W^leftMargin #= 20, W^topMargin #= 20,
    handleWindowClosing(W),

	cgButton(P,"pass"),
    	P^x #= 630, P^y #= 300,
    	P^width #= 100, P^height #= 50,
    	handleButtonPassClick(W,P),

	cgButton(R,"reset"),
    	R^x #= 630, R^y #= 400,
    	R^width #= 100, R^height #= 50,
    	handleButtonResetClick(W,R),
    cgStartRecord(othello),
	drawBoard(8,Comps,[]),
    	cgSame([P,R|Comps],window,W),
    	cgShow([P,R|Comps]),
	put(28,1,W),put(29,2,W),put(36,2,W),put(37,1,W),
    cgStopRecord,
        global_set(state,0,[0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,1,2,0,0,0,
                  0,0,0,2,1,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0]),

	handleMouseEvent(W).	

handleWindowClosing(Win),{windowClosing(Win)} => abort.

handleButtonResetClick(W,R),{actionPerformed(R)} =>
	cgClose(W),
	go.
	
handleButtonPassClick(W,P),{actionPerformed(P)} =>
	main(com,W).

handleMouseEvent(W),{mousePressed(W,E)}=>
	E^x #= X, E^y #= Y,
	mouseClick(W,X,Y).
	
mouseClick(W,X,Y):-
	X > 100, X < 580,
	Y > 100, Y < 580,!,
	J is (Y-100)//60*8+(X-100)//60+1,
	put(J,1,W),global_set(next,0,J),main(man,W).
mouseClick(W,X,Y).

main(com,W):-
	global_get(state,0,C),
        next(C,2,J), !, put2(J,2,W), 
	change(J,2,C,C1), update(J,C1,2,1,C2,W),global_set(state,0,C2),final(W,N).
main(com,W):-
	write('Your turn again.'),nl.
	
main(man,W):-
	global_get(next,0,J),
	global_get(state,0,C),
	J>0,
	find(0,C,J), check(J,C,1,_,0),!,
	change(J,1,C,C1), update(J,C1,1,1,C2,W),
	global_set(state,0,C2),con(W).
main(man,W):-
	write('You can not put there.'),nl,
	global_get(state,0,C),
	global_get(next,0,J),
	find(N,C,J), put(J,N,W).

con(W):-
	final(W,1),!.
con(W):-
	main(com,W).

final(W,1):-
	global_get(state,0,C), 
        not( member(0,C) ), !, count(2,C,N), N1 is 64 - N,
	mas(N,N1,W),
	write('Computer : Human = '),write(N),write(' : '),write(N1),nl.
final(W,0).

mas(N,N1,W):-
	N>N1,!,
	cgLabel(R,"I Win!"),
	R^window #= W,
	R^fontSize #= 50,
	R^fontStyle #= 'bold',
	R^color #= red,
	cgShow(R).
mas(N,N1,W):-
	cgLabel(R,"You Win!"),
	R^window #= W,
	R^fontSize #= 50,
	R^fontStyle #= 'bold',
	R^color #= red,
	cgShow(R).

	
% Check availability / check(Place,Current,Color,Direction,Flag).
check(N,C,M,1,_) :- 
	not( 0 is N mod 8 ), N1 is N + 1, M1 is 3 - M, 
	find(M1,C,N1), check(N1,C,M,1,1).
check(N,C,M,1,1) :- 
	not( 0 is N mod 8 ), N1 is N + 1, find(M,C,N1).
check(N,C,M,2,_) :- 
	not( 1 is N mod 8 ), N1 is N - 1, M1 is 3 - M, 
	find(M1,C,N1), check(N1,C,M,2,1).
check(N,C,M,2,1) :- 
	not( 1 is N mod 8 ), N1 is N - 1, find(M,C,N1).
check(N,C,M,3,_) :- 
	N > 8, N1 is N - 8, M1 is 3 - M, find(M1,C,N1), check(N1,C,M,3,1).
check(N,C,M,3,1) :- 
	N > 8, N1 is N - 8, find(M,C,N1).
check(N,C,M,4,_) :- 
	N < 57, N1 is N + 8, M1 is 3 - M, find(M1,C,N1), check(N1,C,M,4,1).
check(N,C,M,4,1) :- 
	N < 57, N1 is N + 8, find(M,C,N1).
check(N,C,M,5,_) :- 
	not( 0 is N mod 8 ), N > 8, N1 is N - 7, M1 is 3 - M, 
	find(M1,C,N1), check(N1,C,M,5,1).
check(N,C,M,5,1) :- 
	not( 0 is N mod 8 ), N > 8, N1 is N - 7, find(M,C,N1).
check(N,C,M,6,_) :- 
	not( 0 is N mod 8 ), N < 57, N1 is N + 9, M1 is 3 - M, 
	find(M1,C,N1), check(N1,C,M,6,1).
check(N,C,M,6,1) :- 
	not( 0 is N mod 8 ), N < 57, N1 is N + 9, find(M,C,N1).
check(N,C,M,7,_) :- 
	not( 1 is N mod 8 ), N > 8, N1 is N - 9, M1 is 3 - M, 
	find(M1,C,N1), check(N1,C,M,7,1).
check(N,C,M,7,1) :- 
	not( 1 is N mod 8 ), N > 8, N1 is N - 9, find(M,C,N1).
check(N,C,M,8,_) :- 
	not( 1 is N mod 8 ), N < 57, N1 is N + 7, M1 is 3 - M, 
	find(M1,C,N1), check(N1,C,M,8,1).
check(N,C,M,8,1) :- not( 1 is N mod 8 ), N < 57, N1 is N + 7, find(M,C,N1).
    
% Priority
p([1,8,64,57,27,35,20,21,44,45,30,38,19,22,43,46,17,41,3,59,
   6,62,24,48,25,33,4,60,5,61,32,40,26,34,52,53,12,13,31,39,42,
   51,11,18,54,47,14,23,9,49,2,58,7,63,16,56,10,50,15,55]).

next(C,N,J):-
	p(P),next(C,N,P,J).
next(C,N,[H|_],H) :- find(0,C,H),check(H,C,N,_,0), !.
next(C,N,[_|T],J) :- next(C,N,T,J).

% Update board / update(Place, Current, Color, Direction, Updated).
update(_,C,_,9,C,Win).
update(N,C,W,D,C2,Win) :- 
        D1 is D + 1, 
        update(N,C,W,D1,C1,Win),
        ( check(N,C,W,D,0) -> reverse(N,C1,W,D,C2,Win) ; C2 = C1 ).

reverse(N,C,W,1,X,Win) :- % east
        not( 0 is N mod 8 ), N1 is N + 1, change(N1,W,C,C1), put(N1,W,Win), 
	reverse(N1,C1,W,1,X,Win).
reverse(N,C,W,2,X,Win) :- % west
        not( 1 is N mod 8 ), N1 is N - 1, change(N1,W,C,C1), put(N1,W,Win), 
	reverse(N1,C1,W,2,X,Win).
reverse(N,C,W,3,X,Win) :- % north
        N > 8, N1 is N - 8, change(N1,W,C,C1), put(N1,W,Win), 
	reverse(N1,C1,W,3,X,Win).
reverse(N,C,W,4,X,Win) :- % south
        N < 57, N1 is N + 8, change(N1,W,C,C1), put(N1,W,Win), 
	reverse(N1,C1,W,4,X,Win).
reverse(N,C,W,5,X,Win) :- % north-east
        not( 0 is N mod 8 ), N > 8, N1 is N - 7, change(N1,W,C,C1), put(N1,W,Win), 
	reverse(N1,C1,W,5,X,Win).
reverse(N,C,W,6,X,Win) :- % south-east
        not( 0 is N mod 8 ), N < 57, N1 is N + 9, change(N1,W,C,C1), put(N1,W,Win), 
	reverse(N1,C1,W,6,X,Win).
reverse(N,C,W,7,X,Win) :- % north-west
        not( 1 is N mod 8 ), N > 8, N1 is N - 9, change(N1,W,C,C1), put(N1,W,Win), 
	reverse(N1,C1,W,7,X,Win).
reverse(N,C,W,8,X,Win) :- % south-west
        not( 1 is N mod 8 ), N < 57, N1 is N + 7, change(N1,W,C,C1), put(N1,W,Win), 
	reverse(N1,C1,W,8,X,Win).
reverse(_,C,_,_,C,Win).
        
% Tools
count(_,[],0).
count(H,[H|T],X) :- !, count(H,T,W), X is W + 1.
count(E,[_|T],X) :- count(E,T,X).

change(1,E,[X|T],[E|T]) :- E \== X, !.
change(N,E,[H|T],[H|X]) :- N > 1, N1 is N - 1, change(N1,E,T,X).

find(H,[H|_],1).
find(E,[_|T],N1) :- find(E,T,N), N1 is N + 1.

% Graphics
drawBoard(N,[S|Comps],CompsR):-
	drawHorizontalLines(0,N,Comps,Comps1),
    	drawVerticalLines(0,N,Comps1,CompsR),
	cgSquare(S),
	S^x #= 80, S^y #= 80,
	S^width #= 520, S^color #= orange.

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
	
put(N,M,W) :-
	X is (N - 1) mod 8 + 1, Y is (N - 1) // 8 + 1,
	color(M,C),
	cgCircle(S),
	S^window #= W,
    	S^centerX #= X*60+100-30,
    	S^centerY #= Y*60+100-30,
    	S^diameter #= 50,
    	S^color #= C,
	cgSleep(200),
	cgShow(S).

put2(N,M,W) :-
	X is (N - 1) mod 8 + 1, Y is (N - 1) // 8 + 1,
	color(M,C),
	cgCircle(S),
	S^window #= W,
    	S^centerX #= X*60+100-30,
    	S^centerY #= Y*60+100-30,
    	S^diameter #= 50,
    	S^color #= C,
	cgSleep(2000),
	cgShow(S).

color(0,orange).
color(1,black).
color(2,white).

