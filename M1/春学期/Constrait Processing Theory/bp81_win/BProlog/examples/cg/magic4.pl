/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    4*4 magic square puzzle
*********************************************************************/

go:-
    cgWindow(Win,"magic4"),Win^topMargin #= 30,Win^leftMargin #= 10,
    handleWindowClosing(Win),
    magic4(Os),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

magic4(Bs):-
    Vars=[X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16],
    vars_constraints(Vars),
    %
    Bs=[B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16],
    integer_to_string(Vars,Strings),
    cgButton(Bs,Strings),
    cgSame(Bs,fontSize,35), cgSame(Bs,fontStyle,bold),
    cgGrid([[B1,B2,B3,B4],
	    [B5,B6,B7,B8],
	    [B9,B10,B11,B12],
	    [B13,B14,B15,B16]]).

integer_to_string([],[]).
integer_to_string([I|Is],[S|Ss]):-
    number_codes(I,S),
    integer_to_string(Is,Ss).

vars_constraints(Vars):-
    Vars=[X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16],
    Vars in 1..16,
    alldifferent(Vars),
    %
    X1+X2+X3+X4#=34,
    X5+X6+X7+X8#=34,
    X9+X10+X11+X12#=34,
    X13+X14+X15+X16#=34,
    %
    X1+X5+X9+X13#=34,
    X2+X6+X10+X14#=34,
    X3+X7+X11+X15#=34,
    X4+X8+X12+X16#=34,
    %
    X1+X6+X11+X16#=34,
    X4+X7+X10+X13#=34,
    %
    labeling(Vars),!.
