/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw a circle chart based on input data
*********************************************************************/
go:-
    circleChart.
go.

circleChart:-
    circleChart(Os),
    cgWindow(Win,"circleChart"), Win^topMargin #= 20, Win^width #> 600, Win^height #> 600,
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgShow(Os).

circleChart(Os):-
    Arcs = [A1,A2,A3,A4],
    cgArc(Arcs),
    cgSame(Arcs,width,Width), Width #> 500, 
    cgSame(Arcs,height,Height), Height #> 500, 
    A1^color #= red, Ang1 is (20*360)//100, A1^arcAngle #= Ang1,
    A2^color #= blue,  Ang2 is (40*360)//100, A2^arcAngle #= Ang2,
    A3^color #= yellow, Ang3 is (32*360)//100, A3^arcAngle #= Ang3,
    A4^color #= green, Ang4 is 360-Ang1-Ang2-Ang3, A4^arcAngle #= Ang4,
    %
    Labels = [L1,L2,L3,L4],
    cgLabel(Labels,["Apple","Orange","Banana","Other"]),
    %
    Squares = [S1,S2,S3,S4],
    cgSquare(Squares),
    cgSame(Squares,width,20), % all squares are 20 pixles wide
    %
    constrainColor(Squares,Arcs),
    cgLeft(Arcs,Squares),
    %
    cgTable([[S1,L1],
	     [S2,L2],
	     [S3,L3],
	     [S4,L4]],2,2),

    arcsNotOverlap(Arcs),
    %
    Os=[A1,A2,A3,A4,L1,L2,L3,L4,S1,S2,S3,S4].
     
constrainColor([],[]).
constrainColor([Sq|Sqs],[A|As]):-
    Sq^color #= A^color,
    constrainColor(Sqs,As).

arcsNotOverlap([]):-!.
arcsNotOverlap([_Arc]):-!.
arcsNotOverlap([Arc|Arcs]):-
    arcsNotOverlap(Arc,Arcs),
    arcsNotOverlap(Arcs).
    
arcsNotOverlap(_Arc1,[]).
arcsNotOverlap(Arc1,[Arc|Arcs]):-
    (Arc1^startAngle #>= Arc^startAngle+Arc^arcAngle) #\/
     (Arc1^startAngle+Arc1^arcAngle #=< Arc^startAngle),
     arcsNotOverlap(Arc1,Arcs).
		
handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).


