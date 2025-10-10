/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    Draw the USA flag
*********************************************************************/
go:-
    usa(Os),
    cgWindow(Win,"usa"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgScale(Os,0.5),
    cgMove(Os,30,30),
    cgShow(Os).


handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

usa(AllComps):-
    cgRectangle(R),R^color #= white,
    2*R^width #= 3*R^height,

    length(Strips,7),
    cgRectangle(Strips), 
    cgSame(Strips,color,red), cgSame(Strips,width,R^width), cgSame(Strips,height,R^height/13),
    cgSame(Strips,x),
    Strips=[Strip1|_],Strip1^y #= R^y,
    constrainStrips(Strips),


    cgRectangle(BlueRect), BlueRect^color #= blue, BlueRect^x #= R^x, BlueRect^y #= R^y,
    R^width #= 2*BlueRect^width,
    7*R^height #= 13*BlueRect^height,

    length(WhiteStars,50),
    cgStar(WhiteStars),
    cgSame(WhiteStars,n,5), cgSame(WhiteStars,color,white),
    cgSame(WhiteStars,diameter,BlueRect^height/10),
    constrainStars(WhiteStars,BlueRect),
    
    cgRectangle(Frame),Frame^fill#=0,
    cgSame([Frame,R],location), cgSame([Frame,R],size),
    
    append([R|Strips],[BlueRect,Frame|WhiteStars],AllComps).

constrainStrips([_]):-!.
constrainStrips([Strip1,Strip2|Strips]):-
    Strip2^y #= Strip1^y+2*Strip1^height,
    constrainStrips([Strip2|Strips]).

constrainStars(Stars,BlueRect):-
    Stars=[S11,S12,S13,S14,S15,S16,
	   S21,S22,S23,S24,S25,
	   S31,S32,S33,S34,S35,S36,
	   S41,S42,S43,S44,S45,
	   S51,S52,S53,S54,S55,S56,
	   S61,S62,S63,S64,S65,
	   S71,S72,S73,S74,S75,S76,
	   S81,S82,S83,S84,S85,
	   S91,S92,S93,S94,S95,S96],

    S21^centerX #= (S11^centerX+S12^centerX)//2,
    S21^centerY #= (S11^centerY+S31^centerY)//2,
    cgSame([S23,BlueRect],centerX),
    cgInside(Stars,BlueRect),

    Pad #> S11^width,
    cgGrid([[S11,S12,S13,S14,S15,S16],
	    [S31,S32,S33,S34,S35,S36],
	    [S51,S52,S53,S54,S55,S56],
	    [S71,S72,S73,S74,S75,S76],
	    [S91,S92,S93,S94,S95,S96]],Pad,Pad),
    cgGrid([[S21,S22,S23,S24,S25],
	    [S41,S42,S43,S44,S45],
	    [S61,S62,S63,S64,S65],
	    [S81,S82,S83,S84,S85]],Pad,Pad).

