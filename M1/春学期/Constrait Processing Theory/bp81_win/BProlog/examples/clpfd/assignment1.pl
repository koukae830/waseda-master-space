go:-
    Vars = [B11,B12,B13,B14,
	    B21,B22,B23,B24,
	    B31,B32,B33,B34,
	    B41,B42,B43,B44],
    Vars :: 0..1,

    B11+B12+B13+B14 #= 1,
    B21+B22+B23+B24 #= 1,
    B31+B32+B33+B34 #= 1,
    B41+B42+B43+B44 #= 1,
    B11+B21+B31+B41 #= 1,
    B12+B22+B32+B42 #= 1,
    B13+B23+B33+B43 #= 1,
    B14+B24+B34+B44 #= 1,

    P = 7*B11+B12+3*B13+4*B14+
        8*B21+2*B22+5*B23+B24+
        4*B31+3*B32+7*B33+2*B34+
        3*B41+B42+6*B43+3*B44,

    maxof(labeling(Vars),P),
    Profit is P,
    writeln((Vars,Profit)).
    
    
