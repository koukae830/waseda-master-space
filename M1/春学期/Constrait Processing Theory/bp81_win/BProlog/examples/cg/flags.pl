/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    Animate flags
*********************************************************************/
go:-
    cgWindow(Win,"Animating flags"),
%    animate(Win,[australia,antiguabarbuda,aruba,burundi,canada,china,cuba,korea,japan,poland,singapore,saintChristpher,uk,usa,venezuela,westernsahara]).
    animate(Win,[antiguabarbuda,aruba,burundi,canada,china,cuba,korea,japan,poland,singapore,saintChristpher,uk,usa,venezuela,westernsahara]).

animate(Win,Countries):-
    member(Country,Countries),
    Call=..[Country,Comps],
    \+ (call(Call),
	cgSame(Comps,window,Win),
	cgPack(Comps),
	cgResize(Comps,300,200),
	cgMove(Comps,50,50),
	cgClean(Win),
	cgShow(Comps),
	cgSleep(2000)),
    fail.
animate(Win,Countries):-
    cgClose(Win).

%:-include('australia').
:-include('antiguabarbuda').
:-include('aruba').
:-include('burundi').
:-include('canada').
:-include('china').
:-include('cuba').
:-include('korea').
:-include('japan').
:-include('poland').
:-include('saintChristpher').
:-include('singapore').
:-include('uk').
:-include('usa').
:-include('venezuela').
:-include('westernsahara').





