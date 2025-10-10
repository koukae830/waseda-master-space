%by Bobby
go:-
    cgWindow(Win,"MyFace"), Win^width #= 800, Win^height #= 800,
    Win^topMargin #= 100, Win^leftMargin #= 100,
    cgCircle(C),C^width #= 500, C^fill #= 0,
    %
    cgRectangle([E1,E2]),E1^width #= C^width//5,
    E1^width #= 5*E1^height, cgSame([E1,E2],size),
    E1^y #= C^y+C^width//3, E2^y #= E1^y,
    E1^rightX #= C^centerX-C^width//10,C^centerX #= (E1^centerX+E2^centerX)//2,
    %
    cgTriangle(Nose),
    Nose^point1 #= C^center,
    Nose^x2 #= C^centerX-C^width//10,Nose^y2 #= C^centerY+C^width//10,
    Nose^x3 #= C^centerY+C^width//10, Nose^y3 #= Nose^y2,
    %
    cgRectangle(Mouth),Mouth^width #= 5*Mouth^height,
    cgSame([Mouth,E1],size),
    cgSame([Mouth,C],centerX),
    Mouth^y #= C^centerY+3*C^width//10,
    %
    Comps = [C,E1,E2,Nose,Mouth],
    cgSame(Comps,window,Win),
    cgShow(Comps).
go.

    
    
    
    
    
