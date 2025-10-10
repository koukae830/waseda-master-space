/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw the Singaporian flag, originally by Ishikawa
*********************************************************************/
go:-
    singapore(Os),
    cgWindow(Win,"singapore"),
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgPack(Os),
    cgMove(Os,30,30),
    cgJava(singapore,Os).
go.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

singapore(Os):-
  cgRectangle(Flag),
  Flag^color #= white,
  3*Flag^height  #= 2*Flag^width,
  cgRectangle(Frame),Frame^size #= Flag^size,Frame^fill #= 0,
  Frame^width #> 300, Frame^width #<500,

  cgRectangle(RedRec),
  RedRec^color #= red,
  RedRec^width #= Flag^width,
  RedRec^height #= Flag^height//2,
  RedRec^x #= Flag^x,
  RedRec^y #= Flag^y,

  cgCircle(Wc),
  Wc^color #= white,
  Wc^width #= 11*RedRec^height//15,
  Wc^x #= Flag^width//10,
  Wc^centerY #= RedRec^height//2,

  cgCircle(Rc),
  Rc^color #= red,
  Rc^width #= Wc^width,
  Rc^x #= Wc^x + Flag^width//18,
  Rc^y #= Wc^y,

  cgStar(BigS),
  BigS^color #= red,
  BigS^n#= 5,
  BigS^width #= Rc^width/2,
  cgSame([BigS,Rc],centerX),
  cgSame([BigS,RedRec],centerY),

  Stars=[S0,S1,S2,S3,S4],
  cgStar(Stars),
  cgSame(Stars,n,5),
  cgSame(Stars,color,white), 
  cgSame(Stars,width,Width),  Width #=  5*Rc^width//22,

  cgSame([S0,BigS],centerX),
  20*S0^y #= 20*Wc^y + Flag^height,
 
  15*S1^centerX #= 15*S0^centerX + Flag^width,
  15*S1^y #= 15*S0^y + Flag^height,
  
  15*S2^centerX #= 15*S0^x + Flag^width,
  15*S2^y #= 15*S0^centerY + 2*Flag^height,
  
  15*S3^centerX #= 15*S0^x + 15*S0^width -Flag^width,
  S3^y #= S2^y,
  
  15*S4^centerX #= 15*S0^centerX - Flag^width,
  S4^y #= S1^y, 

  Os = [Flag,Frame,RedRec,Wc,Rc|Stars].


