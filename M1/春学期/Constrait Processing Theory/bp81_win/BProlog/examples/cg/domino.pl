go:-
    cgWindow(Win,"Dominos"),
    Win^topMargin #= 100, Win^leftMargin #= 100,
    domino(1,domino(S1,Cs1)),
    domino(2,domino(S2,Cs2)),
    domino(3,domino(S3,Cs3)),
    domino(4,domino(S4,Cs4)),
    domino(5,domino(S5,Cs5)),
    S1^width #= 60,
    cgGrid([[_,S1,_],
	    [S2,S3,S4],
	    [_,S5,_]]),
    cgDefaultWindow(W),W^leftMargin #= 100, W^topMargin #= 100,
    appendLists([Cs1,Cs2,Cs3,Cs4,Cs5],[],Cs),
    cgSame(Cs,width),
    Comps=[S1,S2,S3,S4,S5|Cs],
    cgSame(Comps,window,Win),
    cgShow(Comps).


domino(N,domino(S,Cs)):-
    cgSquare(S),S^fill#=0,
    length(Cs,N),
    cgCircle(Cs),
    cgInside(Cs,S),
    constraint(S,Cs).

constraint(S,[C]):-
    cgSame([S,C],center).
constraint(S,[C1,C2]):-
    cgGrid([[C1,_,_],
	    [_,Dum,_],
	    [_,_,C2]]),
    cgSame([S,Dum],center).
constraint(S,[C1,C2,C3]):-    
    cgGrid([[C1,_,_],
	    [_,C2,_],
	    [_,_,C3]]),
    cgSame([S,C2],center).
constraint(S,[C1,C2,C3,C4]):-    
    cgGrid([[C1,_,C2],
	    [_,Dum,_],
	    [C3,_,C4]]),
    cgSame([S,Dum],center).
constraint(S,[C1,C2,C3,C4,C5]):-    
    cgGrid([[C1,_,C2],
	    [_,C3,_],
	    [C4,_,C5]]),
    cgSame([S,C3],center).

appendLists([],All,All).
appendLists([L1|Ls],All0,All):-
    append(L1,All0,All1),
    appendLists(Ls,All1,All).

    
    

    
