% By Meng Chao(Jason) Chen
go:-
    westernsahara(Os),
    cgWindow(Win,"westernsahara"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgMove(Os,30,30),
    cgShow(Os).
 
handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

westernsahara(Os):-    
  cgRectangle(Frame),Frame^fill #= 0,
  cgRectangle(Bg),Frame^size #= Bg^size,
  Bg^color #=white,
  Bg^height #= 200,
  Bg^width #= 9*Bg^height/5,

  WhiteBox=[W1,W2],
  cgRectangle(WhiteBox),
  cgSame([Bg|WhiteBox],width),
  cgSame(WhiteBox,width),
  cgSame(WhiteBox,height),
  W1^color #= black,
  W2^color #= green,
  W1^height #= Bg^height/3,  
  W1^x #= Bg^x,
  W1^y #= Bg^y,
  W2^x #= Bg^x,
  W2^y #= Bg^y + 2*Bg^height/3,

  cgCircle(Wc),
  Wc^color #= red,
  Wc^width #= Bg^height/4,
  Wc^x #= Bg^width/2,
  Wc^centerY #= Bg^height//2,

  cgCircle(Rc),
  Rc^color #= white,
  Rc^width #= 4*Wc^width/5,
  Rc^x #= Wc^x + Bg^width//30,
  Rc^y #= Wc^y + Bg^width//70,

  cgTriangle(Tri),
  Tri^color #=red,
  Tri^point1 #= Bg^leftTopPoint,
  Tri^point2 #= Bg^leftBottomPoint,
  Tri^x3 #= Bg^x + Bg^width/3,
  Tri^y3 #= Bg^y + Bg^height/2,


  cgStar(Star),
  Star^n #=5,
  Star^color #= red,
  Star^centerX #= Bg^x + 8*Bg^height/7,
  Star^centerY #= Bg^centerY,
  Star^diameter #= Bg^height/7,
  Star^angle0 #= 75,
  
  Os=[Bg,W1,W2,Tri,Wc,Rc,Star,Frame].
