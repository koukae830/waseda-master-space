% By Meng Chao(Jason) Chen
go:-
    burundi(Os),
    cgWindow(Win,"burundi"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgMove(Os,30,30),
    cgShow(Os).
 
handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

burundi(Os):-    
  cgRectangle(Frame),Frame^fill #= 0,
  cgRectangle(Bg),Frame^size #= Bg^size,
  Bg^color #=white,
  Bg^height #= 200,
  Bg^width #= 9*Bg^height/6,

  cgTriangle(Tri1),
  Tri1^color #=green,
  Tri1^x1 #= Bg^x,
  Tri1^y1 #= Bg^y + Bg^height/20,
  Tri1^x2 #= Bg^x,
  Tri1^y2 #= Bg^y + Bg^height - Bg^height/20,
  Tri1^x3 #= Bg^x + 3*Bg^width/7,
  Tri1^y3 #= Bg^y + Bg^height/2,

  cgTriangle(Tri2),
  Tri2^color #=green,
  Tri2^x1 #= Bg^x + Bg^width,
  Tri2^y1 #= Bg^y + Bg^height/20,
  Tri2^x2 #= Bg^x + Bg^width,
  Tri2^y2 #= Bg^y + Bg^height - Bg^height/20,
  Tri2^x3 #= Bg^x + 4*Bg^width/7,
  Tri2^y3 #= Bg^y + Bg^height/2,

  cgTriangle(Tri3),
  Tri3^color #=red,
  Tri3^x1 #= Bg^x + Bg^height/20,
  Tri3^y1 #= Bg^y,
  Tri3^x2 #= Bg^x + Bg^width - Bg^height/20,
  Tri3^y2 #= Bg^y,
  Tri3^x3 #= Bg^x + Bg^width/2,
  Tri3^y3 #= Bg^y + Bg^width/3,

  cgTriangle(Tri4),
  Tri4^color #=red,
  Tri4^x1 #= Bg^x + Bg^height/20,
  Tri4^y1 #= Bg^y + Bg^height,
  Tri4^x2 #= Bg^x + Bg^width - Bg^height/20,
  Tri4^y2 #= Bg^y + Bg^height,
  Tri4^x3 #= Bg^x + Bg^width/2,
  Tri4^y3 #= Bg^y + Bg^height/2,

  cgCircle(Wc),
  Wc^color #= white,
  Wc^width #= Bg^width//3,
  Wc^center #= Bg^center,

  cgStar(Star1),
  Star1^n #=6,
  Star1^color #= green,
  Star1^centerX #= Bg^centerX,
  Star1^centerY #= Bg^centerY - Bg^height/12,
  Star1^diameter #= Bg^height/6,
  
  cgStar(Star4),
  Star4^n #=6,
  Star4^color #= red,
  Star4^centerX #= Bg^centerX,
  Star4^centerY #= Bg^centerY - Bg^height/12,
  Star4^diameter #= Bg^height/9,
  
  cgStar(Star2),
  Star2^n #=6,
  Star2^color #= green,
  Star2^centerX #= Bg^centerX - Bg^height/12,
  Star2^centerY #= Bg^centerY + Bg^height/12,
  Star2^diameter #= Bg^height/6,
  
  cgStar(Star5),
  Star5^n #=6,
  Star5^color #= red,
  Star5^centerX #= Bg^centerX - Bg^height/12,
  Star5^centerY #= Bg^centerY + Bg^height/12,
  Star5^diameter #= Bg^height/9,
  
  cgStar(Star3),
  Star3^n #=6,
  Star3^color #= green,
  Star3^centerX #= Bg^centerX + Bg^height/12,
  Star3^centerY #= Bg^centerY + Bg^height/12,
  Star3^diameter #= Bg^height/6,
  
  cgStar(Star6),
  Star6^n #=6,
  Star6^color #= red,
  Star6^centerX #= Bg^centerX + Bg^height/12,
  Star6^centerY #= Bg^centerY + Bg^height/12,
  Star6^diameter #= Bg^height/9,
  
  Os=[Bg,Tri1,Tri2,Tri3,Tri4,Wc,Star1,Star2,Star3,Star4,Star5,Star6,Frame].
