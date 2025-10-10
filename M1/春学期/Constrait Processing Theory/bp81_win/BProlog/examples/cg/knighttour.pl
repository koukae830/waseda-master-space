/* 
    Find a knight tour that connects all the squares 
    by Neng-Fa Zhou, 2001
*/

go:-
    cgWindow(W,"Knight tour"),
    W^width #= 780, W^height #= 680,
    %
    knight_tour(W,Comps).

knight_tour(Win,Comps):-
    solve(Vars),
    output(Vars,Win,Comps).

solve(Vars):-
    length(Vars,64), % 8*8=64
    computeDomain(Vars,1),
    circuit(Vars),  % built-in
    labeling_ff(Vars).

computeDomain([],N).
computeDomain([V|Vs],N):-
    I is (N-1)//8+1,
    J is N-(I-1)*8,
    feasiblePositions(I,J,D),
    sort(D,SortedD),
    V in SortedD,
    N1 is N+1,
    computeDomain(Vs,N1).

feasiblePositions(I,J,D):-
    I1 is I+1,  J1 is J+2,
    I2 is I+1,  J2 is J-2,
    I3 is I-1,  J3 is J+2,
    I4 is I-1,  J4 is J-2,
    I5 is I+2,  J5 is J+1,
    I6 is I+2,  J6 is J-1,
    I7 is I-2,  J7 is J+1,
    I8 is I-2,  J8 is J-1,
    addFeasiblePositions([(I1,J1),(I2,J2),(I3,J3),(I4,J4),(I5,J5),(I6,J6),(I7,J7),(I8,J8)],D).
    
addFeasiblePositions([],D):-D=[].
addFeasiblePositions([(I,J)|IJs],D):-
    (I>=1,I=<8,J>=1,J=<8),!,
    N is (I-1)*8+J,
    D=[N|D1],
    addFeasiblePositions(IJs,D1).
addFeasiblePositions([_|IJs],D):-
    addFeasiblePositions(IJs,D).

output(Vars,W,AllComps):-
    drawBoard(8,Comps,[]),
    cgSame(Comps,window,W),
    cgPack(Comps),
    %
    Array=..[a|Vars],
    output(Array,1,1,1,W,Lines),
    closetail(Lines),
    append(Comps,Lines,AllComps),
%    cgScale(AllComps,0.3),
    cgShow(AllComps).
    
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

output(Array,I,J,N,Win,Lines):-N>64,!.
output(Array,I,J,N,Win,Lines):-
    P is (I-1)*8+J,
    arg(P,Array,P1),
    I1 is (P1-1)//8+1,
    J1 is P1-(I1-1)*8,
    drawStep(I,J,I1,J1,Win,Lines),
    N1 is N+1,
    output(Array,I1,J1,N1,Win,Lines).

drawStep(I,J,I1,J1,Win,Lines):-
    cgLine(Line),
    LM #= 100, TM #= 100,
    Line^x1 #= (I-1)*60+LM+30, Line^y1 #= (J-1)*60+TM+30,
    Line^x2 #= (I1-1)*60+LM+30, Line^y2 #= (J1-1)*60+TM+30,
    Line^color #= blue,
    cgCircle(Circle),
    Circle^centerX #= Line^x1, Circle^centerY #= Line^y1,
    Circle^width #= 10, Circle^color #= blue,
    Circle^window #= Win,
    Line^window #= Win,
    cgPack([Line,Circle]),
    attach(Line,Lines),
    attach(Circle,Lines).


