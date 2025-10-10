%   File   : zebra.pl
%   Author : Neng-Fa ZHOU
%   Date   : 1992, added GUI in 2001
%   Purpose: solve the five-house puzzle in CLP(FD)
/*
Five house puzzle

Five men with different nationalities live in the first five houses of a street. 
They practice five distinct professions, and each of them has a favorite animal 
and a favorite drink, all of them different. The five houses are painted different 
colors. The following facts are known:

    The English man lives in a red house.
    The Spaniard owns a dog.
    The Japanese is a painter.
    The Italian drinks tea.
    The Norwegian lives in the first house on the left.
    The owner of the green house drinks coffee.
    The green house is on the right of the white one.
    The sculptor breeds snails. 
    The diplomat lives in the yellow house.
    Milk is drunk in the middle house.
    The Norwegian's house is next to the blue one.
    The violinist drinks fruit juice.
    The fox is in the house next to that of the doctor.
    The horse is in the house next to that of the diplomat.
    Who owns a zebra and who drinks water?
*/

go:-
    cgWindow(Win,"zebra"),Win^topMargin #= 30,
    Win^color #= lightGray, Win^width #=600,
    handleWindowClosing(Win),
    zebra(Os),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

zebra(Labels):-
    Vars=[Red,White,Green,Yellow,Blue,
	  English,Spanish,Japanese,Italian,Norwegian,
	  Painter,Sculptor,Violinist,Doctor,Diplomat,
	  Dog,Fox,Horse,Zebra,Snail,
	  Tea,Coffee,Milk,Joice,Water],
    Vars in 1..5,
    alldifferent([English,Spanish,Japanese,Italian,Norwegian]),
    alldifferent([Red,White,Green,Yellow,Blue]),
    alldifferent([Painter,Sculptor,Violinist,Doctor,Diplomat]),
    alldifferent([Dog,Fox,Horse,Zebra,Snail]),
    alldifferent([Tea,Coffee,Milk,Joice,Water]),
    English#=Red,
    Spanish#=Dog,
    Japanese#=Painter,
    Italian#=Tea,
    Norwegian#=1,
    Green#=Coffee,
    Green#=White+1,
    Sculptor#=Snail,
    Diplomat#=Yellow,
    Milk#=3,
    nextTo(Norwegian,Blue),
    Violinist #= Joice,
    nextTo(Fox,Doctor),
    nextTo(Horse,Diplomat),
    % labeling
    labeling(Vars),
    % show solution
    Texts=[ "Red","White","Green","Yellow","Blue",
	    "English","Spanish","Japanese","Italian","Norwegian",
	    "Painter","Sculptor","Violinist","Doctor","Diplomat",
	    "Dog","Fox","Horse","Zebra","Snail",
	    "Tea","Coffee","Milk","Joice","Water"],
    length(Labels,25),
    Labels=[Lred,Lwhite,Lgreen,Lyellow,Lblue|_],
    cgLabel(Labels,Texts),
    cgSame(Labels,fontSize,14),
    constrainColors([Lred,Lwhite,Lgreen,Lyellow,Lblue],[red,white,green,yellow,blue]),
    constrainX(Labels,Vars),
    constrainY(Labels,50).

constrainColors([],_).
constrainColors([L|Ls],[C|Cs]):-
    L^color #= C,
    constrainColors(Ls,Cs).
    
constrainX([],Vars).
constrainX([L|Ls],[Position|Positions]):-
    L^x #= Position*100,
    constrainX(Ls,Positions).

constrainY([],Y).
constrainY([L1,L2,L3,L4,L5|Ls],Y):-
    cgSame([L1,L2,L3,L4,L5],y,Y),
    Y1 is Y+20,
    constrainY(Ls,Y1).
    
nextTo(X,Y):-
    X #\= Y,
    X #> Y #=> X #= Y+1,
    X #< Y #=> X #= Y-1.


