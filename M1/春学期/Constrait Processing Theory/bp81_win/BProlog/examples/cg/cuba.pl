/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw the Cubian flag.
*********************************************************************/
go:-
    cuba(Os),
    cgWindow(Win,"cuba"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgMove(Os,30,30),
    cgShow(Os).
 
handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

cuba(Os):-    
  cgRectangle(Frame),Frame^fill #= 0,
  cgRectangle(Bg),Frame^size #= Bg^size,
  Bg^color #=blue,
  Bg^width #= 2*Bg^height,

  WhiteBox=[W1,W2],
  cgRectangle(WhiteBox),
  cgSame(WhiteBox,color,white),
  cgSame([Bg|WhiteBox],width),
  cgSame(WhiteBox,width),
  cgSame(WhiteBox,width),
  5*W1^height #= Bg^height,  
  W1^x #= Bg^x,
  W1^y #= Bg^y + Bg^height/5,
  W2^x #= Bg^x,
  W2^y #= Bg^y + 3*Bg^height/5,


  cgTriangle(Tri),
  Tri^color #=red,
  Tri^point1 #= Bg^leftTopPoint,
  Tri^point2 #= Bg^leftBottomPoint,
  Tri^x3 #= Bg^x + 3*Bg^width/7,
  Tri^y3 #= Bg^y + Bg^height/2,


  cgStar(Star),
  Star^n #=5,
  Star^color #= white,
  Star^centerX #= Bg^x + Bg^width/7,
  Star^centerY #= Bg^centerY,
  Star^diameter #= Bg^height/4,

  Os=[Bg,W1,W2,Tri,Star,Frame].
