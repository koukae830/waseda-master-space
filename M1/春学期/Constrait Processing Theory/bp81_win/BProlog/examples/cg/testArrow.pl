go:-    
    cgWindow(Win,"Arrows"), Win^topMargin #= 30, Win^leftMargin #= 10,
    handleWindowClosing(Win),
    cgSquare([R1,R2,R3,R4,R5,R6]), %layout areas
    R1^width #>100,
    cgGrid([[R1,R2],
	    [R3,R4],
	    [R5,R6]]),
    cgSame([R1,R2,R3,R4,R5,R6],window,Win),
    cgPack([R1,R2,R3,R4,R5,R6]), % determine layout areas first
    
    cgLine(L1),
    L1^point1 #= R1^rightBottomPoint,
    L1^point2 #= R1^leftTopPoint,
    L1^arrow1 #= 1,
    
    %
    cgLine(L2),
    L2^point1 #= R2^leftBottomPoint,
    L2^point2 #= R2^rightTopPoint,
    L2^arrow1 #= 1, L2^arrow2 #= 1,
    %
    cgLine(L3),
    L3^point1 #= R3^rightTopPoint,
    L3^point2 #= R3^leftBottomPoint,
    L3^thickness #= 10, L3^arrow1 #= 1, L3^arrowLength1 #= 20, L3^arrowThickness1 #= 20,
    %
    cgLine(L4),
    L4^point1 #= R4^leftTopPoint,
    L4^point2 #= R4^rightBottomPoint,
    L4^thickness #= 10, 
    L4^arrow1 #= 1, L4^arrowThickness1 #= 15,
    L4^arrow2 #= 1, L4^arrowThickness2 #= 20,
    %
    cgLine(L5),
    L5^point1 #= R5^topCenterPoint,
    L5^point2 #= R5^bottomCenterPoint,
    L5^arrow2 #= 1,
    %
    cgLine(L6),
    L6^point1 #= R6^leftCenterPoint,
    L6^point2 #= R6^rightCenterPoint,
    L6^arrow2 #= 1,
    %
    cgSame([L1,L2,L3,L4,L5,L6],window,Win),
    cgShow([L1,L2,L3,L4,L5,L6]).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).
