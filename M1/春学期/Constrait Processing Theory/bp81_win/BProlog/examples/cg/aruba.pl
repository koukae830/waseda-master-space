/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    Drawing the flag of Aruba
*********************************************************************/

go:-
    aruba(Comps),
    cgWindow(Win,"aruba"),
    handleWindowClosing(Win),
    cgSame(Comps,window,Win),
    cgPack(Comps),
    cgMove(Comps,30,30),
    cgShow(Comps).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

aruba(Comps):-
    cgRectangle(Bl),
    Bl^color #=blue,
    Bl^width #=420,
    13*Bl^width #= 21*Bl^height,

    Recs=[R1,R2],
    cgRectangle(Recs),
    cgSame(Recs,color),
    cgSame(Recs,size),
    cgSame(Recs,x),

    R1^color #= orange,
    cgSame([R1,Bl],x),
    cgSame([R1,Bl],width),
    R1^y #= Bl^y + 13*Bl^height/20,
    50*R1^height #=3*Bl^height,

    R2^y #=R1^y + 2*R1^height,

    Stars=[S0,S1],
    cgStar(Stars),
    cgSame(Stars,n,4),
    cgSame(Stars,angle0,90),
    cgSame(Stars,center),
    S0^color #=white,
    5*S0^centerX #= Bl^height,
    S0^centerY #= S0^centerX,
    50*S0^diameter #=9*Bl^width,
    3*S0^innerDiameter #=S0^diameter,
    S1^color #=red,
    20*S1^diameter #=19*S0^diameter,
    3*S1^innerDiameter #= S1^diameter,

    Comps=[Bl,S0,S1|Recs].

