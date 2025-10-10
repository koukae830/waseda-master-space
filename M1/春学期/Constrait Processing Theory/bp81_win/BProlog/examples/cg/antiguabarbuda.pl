/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    Drawing the flag of AntiguaAndBarbuda
*********************************************************************/
go:-
    antiguabarbuda.
go.

antiguabarbuda:-
    antiguabarbuda(Os),
    cgWindow(Win,"antiguaAndBarbuda"), Win^topMargin #= 40, Win^leftMargin #= 10,
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgShow(Os).

antiguabarbuda([R,TR1,S,TR2,TR3]):-
    cgRectangle(R), R^color #= red, 2*R^width #= 3*R^height,

    cgTriangle(TR1), TR1^color #= black, 
    TR1^point1 #= R^leftTopPoint,
    TR1^point2 #= R^rightTopPoint,
    TR1^x3 #= R^centerX, TR1^y3 #= R^bottomY,

    cgStar(S), S^color #= yellow, S^n #= 16,
    S^centerX #= R^x+R^width/2,
    35*S^diameter #= 24*R^height,
    7*S^innerDiameter #= 2*R^width,
    
    cgTriangle(TR2), TR2^color #= blue,
    210*(TR2^x1-R^x) #= 41*R^width,
    28*(TR2^y1-R^y) #= 11*R^height,
    TR2^y1 #= S^centerY,
    210*(TR2^x2-R^x) #= 169*R^width,
    TR2^y2 #= TR2^y1,
    TR2^point3 #= TR1^point3,
    
    cgTriangle(TR3), TR3^color #= white,
    10*(TR3^x1-R^x) #= 3*R^width,
    28*(TR3^y1-R^y) #= 17*R^height,
    10*(TR3^x2-R^x) #= 7*R^width, 
    TR3^y2 #= TR3^y1, 
    TR3^point3 #= TR1^point3.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).







