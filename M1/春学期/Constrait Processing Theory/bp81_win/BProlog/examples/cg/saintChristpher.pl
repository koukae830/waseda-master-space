/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw the Saint Christpher and Navis Flag, originally by Ishikawa, modified by Liya
*********************************************************************/
go:-
    saintChristpher(Os),
    cgWindow(Win,"saintChristpher"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgMove(Os,30,30),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

saintChristpher(Os):-
  cgRectangle(Flag), 
  Flag^color#=blue,
  2*Flag^width #= 3*Flag^height,

  cgTriangle(RT),
  RT^color #= red,
  RT^point1 #=Flag^rightBottomPoint,
  RT^point2 #=Flag^leftBottomPoint,
  RT^point3 #= Flag^rightTopPoint,

  cgTriangle(GT),
  GT^color #= green,
  GT^point1 #=Flag^leftTopPoint,
  GT^point2 #=Flag^leftBottomPoint,
  GT^point3 #= Flag^rightTopPoint,

  hexagon(X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,black,WS1),
  X1#=Flag^x,
  Y1 #=Flag^y+Flag^height,  
  X2 #=X1,
  28*Y2 #= 28*Flag^y+23*Flag^height,
  6*X3 #=6*Flag^x + 5*Flag^width,
  Y3 #= Flag^y ,
  X4 #= Flag^x + Flag^width,
  Y4 #=Y3,
  X5 #=X4,
  28*Y5 #=28*Flag^y+5*Flag^height,
  6*X6 #= 6*Flag^x +Flag^width,
  Y6 #= Y1,


  twohalfPolys(Tris1,XP1,YP1,XP2,YP2,XP3,YP3,XP4,YP4,yellow),
  XP1 #=Flag^x,
  140*YP1 #=140*Flag^y + 103*Flag^height,
  105*XP2 #= 105*Flag^x + 79*Flag^width,
  YP2 #= Flag^y,
  6*XP3 #= 6*Flag^x + 5*Flag^width,
  YP3 #= YP2,
  XP4 #=XP1,
  28*YP4 #= 28*Flag^y + 23*Flag^height,

  twohalfPolys(Tris2,XPb1,YPb1,XPb2,YPb2,XPb3,YPb3,XPb4,YPb4,yellow),
  6*XPb1 #=6*Flag^x + Flag^width,
  YPb1 #=Flag^y + Flag^height,
  XPb2 #= Flag^x + Flag^width,
  28*YPb2 #= 28*Flag^y + 5*Flag^height,
  XPb3 #= XPb2,
  140*YPb3 #= 140*Flag^y + 37*Flag^height,
  105*XPb4 #=105*Flag^x + 26*Flag^width,
  YPb4 #= YPb1,

  append(Tris1,Tris2,Tris),
  append(WS1,Tris,WT),

  Stars=[Star0,Star1],
  cgStar(Stars),
  cgSame(Stars,n,5),
  cgSame(Stars,color,white),
  cgSame(Stars,angle0,15),
  7*Star0^diameter#= 2*Flag^height,
  Star1^diameter #= Star0^diameter,
  35*Star0^centerX #= 35*Flag^x + 11*Flag^width,
  10*Star0^centerY #= 10*Flag^y + 7*Flag^height,
  10*Star1^centerX #= 10*Flag^x + 7*Flag^width,
  28*Star1^centerY #= 28*Flag^y + 9*Flag^height,

  append(WT,Stars,WTS),
  Os=[Flag,GT,RT|WTS].



% a poly made up by two triangles and one 4-point poly
hexagon(X1,Y1,X2,Y2,X3,Y3,X4,Y4,X5,Y5,X6,Y6,Color,List):-
    List=[Ta,Reca,Recb,Tb],
    cgTriangle([Ta,Tb]),    
    cgSame([Ta,Tb],color,Color),
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

 

