/****************************************************************
*   Constraint-based Graphical Programming in B-Prolog          *
*   %                                                           *
*   draw American, Italian, Polish, and Venezuelan flags        *
*   %                                                           *
*   CIS 719.3  Janusz A Skorwider                               *
****************************************************************/

go:-
    venezuela(Os),
    cgWindow(Win,"venezuela"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgMove(Os,15,40),
    cgShow(Os).
go.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

venezuela(Os):-
  cgRectangle(Flag),
  Flag^color #= yellow,
  3*Flag^height  #= 2*Flag^width,
  cgRectangle(Frame),Frame^size #= Flag^size,Frame^fill #= 0,
  Frame^width #> 100, Frame^width #<500,

  cgRectangle(BlueRec),
  BlueRec^color #= blue,
  BlueRec^width #= Flag^width,
  BlueRec^height #= Flag^height//3,
  BlueRec^x #= Flag^x,
  BlueRec^y #= Flag^y+Flag^height//3,

  cgRectangle(RedRec),
  RedRec^color #= red,
  RedRec^width #= Flag^width,
  RedRec^height #= Flag^height//3,
  RedRec^x #= Flag^x,
  RedRec^y #= Flag^y+Flag^height * 2/3,

  cgCircle(Rc),
  Rc^color #= blue,            %   just for setting the stars
  Rc^width #= Flag^width//300, %3  in the right places
  Rc^x #= Flag^width//2,       %3
  12*Rc^y #= 5*Flag^height,

  Stars=[S0,S1,S2,S3,S4,S5,S6],
  cgStar(Stars),
  cgSame(Stars,n,5),
  cgSame(Stars,color,white), 
  cgSame(Stars,width,Width), Width #= Flag^width//18,

  cgSame([S0,Rc],centerX),
  14*S0^y #= 5*Flag^height-50,

  13*S1^centerX #= 5*Flag^width+135,
  29*S1^y #= 11*Flag^height,
  
  3*S2^centerX #= Flag^width+15,
  28*S2^y #= 13*Flag^height,
  
  16*S3^centerX #= 5*Flag^width+50,
  7*S3^y #= 4*Flag^height,
  
  8*S4^centerX #= 5*Flag^width-100, 
  S4^y #= S1^y, 

  3*S5^centerX #= 2*Flag^width-15,
  S5^y #= S2^y,
  
  16*S6^centerX #= 11*Flag^width,
  S6^y #= S3^y,

  Os = [Flag,BlueRec,RedRec,Frame,Rc|Stars].



