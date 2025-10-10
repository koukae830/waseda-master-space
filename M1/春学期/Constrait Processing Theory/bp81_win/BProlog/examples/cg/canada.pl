/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    Flag of Canada by Particle (http://www.theparticle.com/)
*********************************************************************/
go:-
    canada(Os),
    cgWindow(Win,"canada"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgResize(Os,300,200),
    cgMove(Os,50,50),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

canada(AllComps):-

    cgRectangle(R),R^fill #= 0,R^color #= black,
    R^width #= 250,
    R^height #= 125,

    cgRectangle([Strip1,Strip2]),

    cgSame([Strip1,Strip2],color,red),
    cgSame([Strip1,Strip2],width,R^width/4),
    cgSame([Strip1,Strip2],height,R^height),
    cgSame([Strip1,Strip2],y,R^y),
    Strip1^x #= R^x,
    Strip2^x #= R^width-Strip2^width,

    cgPolygon(Polygon),Polygon^color #= red,
    Polygon^n #= 25,
    Polygon^x(1) #= 124,
    Polygon^y(1) #= 114,
    Polygon^x(2) #= 124,
    Polygon^y(2) #= 89,
    Polygon^x(3) #= 99,
    Polygon^y(3) #= 93,
    Polygon^x(4) #= 102,
    Polygon^y(4) #= 84,
    Polygon^x(5) #= 77,
    Polygon^y(5) #= 62,
    Polygon^x(6) #= 84,
    Polygon^y(6) #= 59,
    Polygon^x(7) #= 79,
    Polygon^y(7) #= 42,
    Polygon^x(8) #= 93,
    Polygon^y(8) #= 45,
    Polygon^x(9) #= 97,
    Polygon^y(9) #= 38,
    Polygon^x(10) #= 111,
    Polygon^y(10) #= 51,
    Polygon^x(11) #= 107,
    Polygon^y(11) #= 22,
    Polygon^x(12) #= 116,
    Polygon^y(12) #= 26,
    Polygon^x(13) #= 126,
    Polygon^y(13) #= 9,
    Polygon^x(14) #= 136,
    Polygon^y(14) #= 26,
    Polygon^x(15) #= 145,
    Polygon^y(15) #= 22,
    Polygon^x(16) #= 141,
    Polygon^y(16) #= 51,
    Polygon^x(17) #= 154,
    Polygon^y(17) #= 38,
    Polygon^x(18) #= 158,
    Polygon^y(18) #= 45,
    Polygon^x(19) #= 172,
    Polygon^y(19) #= 42,
    Polygon^x(20) #= 169,
    Polygon^y(20) #= 59,
    Polygon^x(21) #= 174,
    Polygon^y(21) #= 62,
    Polygon^x(22) #= 150,
    Polygon^y(22) #= 84,
    Polygon^x(23) #= 152,
    Polygon^y(23) #= 93,
    Polygon^x(24) #= 127,
    Polygon^y(24) #= 89,
    Polygon^x(25) #= 127,
    Polygon^y(25) #= 114,
    AllComps = [Strip1,Strip2,Polygon,R].



