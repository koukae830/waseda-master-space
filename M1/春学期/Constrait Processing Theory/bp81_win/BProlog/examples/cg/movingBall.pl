/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    a moving ball in a rectangle
*********************************************************************/
go:-
    cgWindow(Win,"movingBall"),
    handleWindowClosing(Win),
    cgCircle(Ball), Ball^color #= red, Ball^width #=50,
    X is random mod 100, Y is random mod 100,
    Ball^x #= X, Ball^y #= Y,
    Ball^window #= Win,
    timer(Timer,40),
    timer_start(Timer),
    moving(Timer,Win,Ball,delta(3,6)). %Dx=1,Dy=3

moving(Timer,Win,Ball,Change),{time(Timer)} =>
    Change=delta(Dx,Dy),
    cgShow(Ball),
%    statistics,
    updateData(Win,Ball,Change).

updateData(Win,Ball,Change):-
    Change=delta(Dx,Dy),
    Ball^x #:= Ball^x + Dx,
    Ball^y #:= Ball^y + Dy,
    bounce(Win,Ball,Change).
    
bounce(Win,Ball,Change):-
    Win^width #= WinW,
    Win^height #= WinH,
    Ball^x #= BallX,
    Ball^y #= BallY,
    Ball^rightX #= BallRX,
    Ball^bottomY #= BallBY,
    bounce(WinW,WinH,BallX,BallY,BallRX,BallBY,Change).

bounce(WinW,WinH,BallX,BallY,BallRX,BallBY,Change):-
    Change=delta(Dx,Dy), 
    ((Dx>0,BallRX>=WinW)->
     NewDx is -abs(Dy),
     NewDy is sign(Dy)*Dx;
     (Dx<0,BallX=<0)->
     NewDx is abs(Dy),
     NewDy is -sign(Dy)*Dx;
     (Dy>0,BallBY>=WinH)->     
     NewDy is -abs(Dx),
     NewDx is sign(Dx)*Dy;
     (Dy<0,BallY=<30)->     
     NewDy is abs(Dx),
     NewDx is -sign(Dx)*Dy;
     NewDx is Dx,
     NewDy is Dy),
    setarg(1,Change,NewDx),
    setarg(2,Change,NewDy).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

    
