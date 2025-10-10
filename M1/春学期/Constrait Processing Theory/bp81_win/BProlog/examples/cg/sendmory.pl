/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    solve the SEND+MORE=MONEY puzzle
*********************************************************************/
go:-
    cgWindow(Win,"sendmory"),Win^topMargin #= 50, Win^leftMargin #= 20,
    handleWindowClosing(Win),
    sendmory(Os),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

sendmory(Comps):-
    Vars=[S,E,N,D,M,O,R,Y],
    Vars in 0..9,
    alldifferent(Vars),
    S#\=0,
    M#\=0,
    1000*S+100*E+10*N+D+1000*M+100*O+10*R+E#=10000*M+1000*O+100*N+10*E+Y,
    labeling(Vars),
    % show solution
    Labels=[Ds,De,Dn,Dd,Em,Eo,Er,Ee,Ym,Yo,Yn,Ye,Yy,Plus],
    atomic_2_strings([S,E,N,D,M,O,R,E,M,O,N,E,Y,'+'],Strings),
    cgLabel(Labels,Strings),
    cgSame(Labels,fontSize,40), cgSame(Labels,fontStyle,bold),
    cgRectangle(Rect),
    cgLine(Line), Line^y1 #= Line^y2, Line^y1 #= Rect^centerY, Line^x1 #= Rect^x, Line^x2 #= Rect^rightX,

    cgGrid([[_,Ds,De,Dn,Dd],
	    [Plus,Em,Eo,Er,Ee],
	    [Rect, Rect, Rect, Rect,Rect],
	    [Ym,Yo,Yn,Ye,Yy]],10,10),

    %
    Comps=[Ds,De,Dn,Dd,
	   Plus,Em,Eo,Er,Ee,
	   Line,
	   Ym,Yo,Yn,Ye,Yy].

atomic_2_strings([],[]).
atomic_2_strings([X|Xs],[S|Ss]):-
    name(X,S),
    atomic_2_strings(Xs,Ss).
