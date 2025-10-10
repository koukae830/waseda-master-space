/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw the flag of UK, by Yamauchi, modified by Liya
*********************************************************************/
go:-
    uk(Os),
    cgWindow(Win,"uk"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgMove(Os,30,30),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

uk(Os):-
  % background of flag
  cgRectangle(Flag),  
  Flag^color #= blue,    
  2*Flag^width #= 3*Flag^height,
  
  % white backward  hexagon  
  hexagon(X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,white,WS1),
  X1#=Flag^x,
  Y1 #=Flag^y,  
  42*X2 #=42*Flag^x + 5*Flag^width,
  Y2 #= Y1,
  X3 #=Flag^x + Flag^width,
  35*Y3 #= 35*Flag^y + 31*Flag^height,
  X4 #= X3,
  Y4 #=Flag^y + Flag^height,
  42*X5 #=42*Flag^x + 37*Flag^width,
  Y5 #=Y4,
  X6 #= X1,
  35*Y6 #= 35*Y1+4*Flag^height,

  % white forward hexagon
  hexagon(X21,Y21,X22,Y22,X23,Y23,X24,Y24,X25,Y25,X26,Y26,white,WS2),
  X21 #=Flag^x + Flag^width,
  Y21 #=Flag^y,  
  X22 #=X21,
  35*Y22 #= 35*Flag^y + 4*Flag^height,
  42*X23 #=42*Flag^x + 5*Flag^width,
  Y23 #= Flag^y + Flag^height,
  X24 #= Flag^x,
  Y24 #=Y23,
  X25 #=X24,
  35*Y25 #=35*Flag^y + 31*Flag^height,
  42*X26 #= 42*Flag^x + 37*Flag^width,
  Y26 #= Y21,

  append(WS1,WS2,WS),

  % lefttop red poly  
  twohalfPolys(R1,RX1,RY1,RX2,RY2,RX3,RY3,RX4,RY4,red),
  RX1 #= Flag^x,
  RY1 #= Flag^y,
  RX2 #= Flag^centerX,
  RY2 #= Flag^centerY,
  RX3 #= RX2 - Flag^width//14,
  RY3 #= RY2,
  RX4 #= RX1,
  35*RY4 #= 35*Flag^y + 3*Flag^height,
 
  % righttop red poly
  twohalfPolys(R2,RX21,RY21,RX22,RY22,RX23,RY23,RX24,RY24,red),
  RX21 #= Flag^x + Flag^width,
  RY21 #= Flag^y + Flag^height,
  RX22 #= Flag^centerX,
  RY22 #= Flag^centerY,
  RX23 #= RX22 + Flag^width//14,
  RY23 #= RY22,
  RX24 #= RX21,
  35*RY24 #= 35*Flag^y + 32*Flag^height,
  
  append(R1,R2,R12),
 
  % leftbottom red poly
  twohalfPolys(R3,RX31,RY31,RX32,RY32,RX33,RY33,RX34,RY34,red),
  RX31 #= Flag^x,
  RY31 #= Flag^y + Flag^height,
  RX32 #= Flag^centerX,
  RY32 #= Flag^centerY,
  RX33 #= RX32 + Flag^width//14,
  RY33 #= RY32,
  RX34 #= Flag^x + Flag^width/14,
  RY34 #= RY31,
 
  % rightbottom red poly
  twohalfPolys(R4,RX41,RY41,RX42,RY42,RX43,RY43,RX44,RY44,red),
  RX41 #= Flag^x + Flag^width,
  RY41 #= Flag^y,
  RX42 #= Flag^centerX,
  RY42 #= Flag^centerY,
  RX43 #= RX42 - Flag^width//14,
  RY43 #= RY42,
  RX44 #= RX41- Flag^width/14,
  RY44 #= RY41,

  append(R3,R4,R34),
  append(R12,R34,RR),
  append(WS,RR,WSR),

  % red and white crosses
  Recs=[CWh,CWv,CRh,CRv],
  cgRectangle(Recs),
  cgSame([CRh,CRv],color,red),
  cgSame([CWh,CWv],color,white),
  15*CRv^width #= 2*Flag^width,
  CRv^height #= Flag^height,
  30*CRv^x #= 30*Flag^x + 13*Flag^width,
  CRv^y #= Flag^y,
  CRh^width #= Flag^width,
  CRh^height #= CRv^width,
  CRh^x #=Flag^x,
  5*CRh^y #= 5*Flag^y + 2*Flag^height,
  35*CWv^width #= 8*Flag^width,
  CWv^height #= Flag^height,
  70*CWv^x #= 70*Flag^x + 27*Flag^width,
  CWv^y #= Flag^y, 
  CWh^width #= Flag^width,
  CWh^height #= CWv^width,
  CWh^x #=Flag^x,
  70*CWh^y #= 70*Flag^y + 23*Flag^height,
  
  append(WSR,Recs,WRs),
%  cgPack(WRs),
  Os=[Flag|WRs].

% a poly made up by two triangles and one 4-point poly
hexagon(X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,Color,List):-
    List=[Ta,Reca,Recb,Tb],
    cgTriangle([Ta,Tb]),    
    cgSame([Ta,Tb],color,Color),
    Ta^fill #=0,
    Ta^x1 #= X1,
    Ta^y1 #= Y1,
    Ta^x2 #= X2,
    Ta^y2 #= Y2,
    Ta^x3 #= X6,
    Ta^y3 #= Y6,
     
    Tb^x1 #= X3,
    Tb^y1 #= Y3,
    Tb^x2 #= X4,
    Tb^y2 #= Y4,
    Tb^x3 #= X5,
    Tb^y3 #= Y5,

    twohalfPolys([Reca,Recb],X2,Y2,X3,Y3,X5,Y5,X6,Y6,Color).

    

% a poly made up by two triangles
twohalfPolys(Tris,X1,Y1,X2,Y2,X3,Y3,X4,Y4,Color):-
  Tris=[Ta,Tb],
  cgTriangle(Tris),
  cgSame(Tris,color,Color),
  Ta^fill #=0,
  Ta^x1 #= X1,
  Ta^y1 #= Y1,
  Ta^x2 #= X2,
  Ta^y2 #= Y2,
  Ta^x3 #= X3,
  Ta^y3 #= Y3,

  Tb^x1 #= X1,
  Tb^y1 #= Y1,
  Tb^x2 #= X4,
  Tb^y2 #= Y4,
  Tb^x3 #= X3,
  Tb^y3 #= Y3.

 
