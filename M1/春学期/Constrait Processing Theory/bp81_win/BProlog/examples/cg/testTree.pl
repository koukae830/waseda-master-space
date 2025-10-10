go:-
    cgWindow(Win,"testTree"), Win^topMargin #= 30, Win^leftMargin #= 30,
    handleWindowClosing(Win),
    tree(Win,top_down,centered,TopDown1),
    tree(Win,top_down,itemized,TopDown2),
    tree(Win,bottom_up,centered,BottomUp1),
    tree(Win,bottom_up,itemized,BottomUp2),
    tree(Win,left_right,centered,LeftRight1),
    tree(Win,left_right,itemized,LeftRight2),
    tree(Win,right_left,centered,RightLeft1),
    tree(Win,right_left,itemized,RightLeft2),

    Rects=[R1,R2,R3,R4,R5,R6,R7,R8],
    cgRectangle(Rects),
    cgSame(Rects,window,Win),
    R1^width #= 120, R1^height #= 60,
    cgSame([R1,R2,R3,R4,R5,R6,R7,R8],size),
    Labs=[LabTD1,LabTD2,LabBU1,LabBU2,LabLR1,LabLR2,LabRL1,LabRL2],
    cgLabel(Labs,
	    ["Top-down centered",
	     "Top-down itemized",
	     "Buttom-up centered",
	     "Buttom-up itemized",
	     "Left-right centered",
	     "Left-right itemized",
	     "Right-left centered",
	     "Right-left itemized"]),
    cgSame(Labs,window,Win),cgSame(Labs,fontSize,12),cgSame(Labs,color,blue),

    cgTable([[LabTD1,LabTD2,LabBU1,LabBU2],
	     [R1,R2,R3,R4],
	     [LabLR1,LabLR2,LabRL1,LabRL2],
	     [R5,R6,R7,R8]],30,10),
    cgPack([LabTD1,LabTD2,LabBU1,LabBU2,LabLR1,LabLR2,LabRL1,LabRL2,R1,R2,R3,R4,R5,R6,R7,R8]),
    resizeAndMove([TopDown1,TopDown2,BottomUp1,BottomUp2,LeftRight1,LeftRight2,RightLeft1,RightLeft2],[R1,R2,R3,R4,R5,R6,R7,R8]),
    cgStartRecord(testTree),
    cgShow([LabTD1,LabTD2,LabBU1,LabBU2,LabLR1,LabLR2,LabRL1,LabRL2]),
    showTrees([TopDown1,TopDown2,BottomUp1,BottomUp2,LeftRight1,LeftRight2,RightLeft1,RightLeft2]),
    cgStopRecord.

resizeAndMove([O|Os],[R|Rs]):-
    cgPack(O),
    R^x #= X,
    R^y #= Y,
    cgMove(O,X,Y),
    resizeAndMove(Os,Rs).
resizeAndMove([],[]).

showTrees([T|Ts]):-cgShow(T),showTrees(Ts).
showTrees([]).

tree(Win,Type,Centered,Cs):-
    buildTree(Win,Tree,Cs),
    cgTree(Tree,Type,10,10,Centered).

buildTree(Win,Tree,Cs):-
    Cs=[C0,C1,C2,C3,C4,C5,C6],
    cgSquare(Cs), cgSame(Cs,window,Win),
    C0^width #= 10, cgSame(Cs,width),
    Tree=node(C0,[node(C1,[node(C3,[]),
			   node(C4,[])]),
		  node(C2,[node(C5,[]),
			   node(C6,[])])]).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

    


    
