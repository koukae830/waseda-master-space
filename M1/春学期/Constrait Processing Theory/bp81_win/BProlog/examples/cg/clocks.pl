/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    clocks that show different local times
    (C) Afany Software
*********************************************************************/
go:-
    cgWindow(Win,"clocks"), Win^topMargin #= 30, Win^leftMargin #= 10, 
    Win^width #= 910, Win^height #= 200,
    clocks(["Beijing","Cairo","LA","London","Moscow","NY","Paris","Sydney","Tokyo"],
           [-12      ,-8     ,4   ,-5      ,-7      ,0        ,-6     ,-14     ,-13], %time differrences from NY
	   Clocks,Win),
    constrainClocks(Clocks),
    packClocks(Clocks),
    showClocks(Clocks),
    handleWindowClosing(Win,Flag),
    timer(Timer,1000),
    timer_start(Timer),
    time_handler(Clocks,Timer,Flag).

clocks([],_,Clocks,Win):-Clocks=[].
clocks([CityName|Names],[Dif|Difs],[Clock|Clocks],Win):-
    Clock=clock(Label,Rect,Circle,Digit,Analog,Dif),
    cgLabel(Label,CityName), Label^fontSize #= 12, Label^fontStyle #= bold,
    cgRectangle(Rect),Rect^fill #= 0,
    Label^width #= 90, 
    cgSetAlignment(Label,center),
    Rect^width #= 90,
    cgCircle(Circle),Circle^fill #= 0,
    Circle^width #= 90,
    cgSameColumn([Label,Rect,Circle]),
    cgSame([Label,Rect,Circle],window,Win),
    %
    digitClock(Digit,Rect,Win),
    %
    analogClock(Analog,Circle,Win),
    clocks(Names,Difs,Clocks,Win).

/* build a digit clock in the area Rect */
digitClock(Digit,Rect,Win):-
    Digit=digit(Hour,Minute,Second,Sep1,Sep2),
    Comps=[Hour,Sep1,Minute,Sep2,Second],
    cgString(Comps,["00",":","00",":","00"]),
    cgSame(Comps,fontSize,12),
    cgSame(Comps,fontStyle,bold),
    Minute^center #= Rect^center,
    cgTable([Comps]),
    cgInside(Comps,Rect),   % whould like to but inefficient
    cgSame(Comps,window,Win).

/* build an analog clock in the area Cicle */
analogClock(Analog,Circle,Win):-
    Analog=analog(Circle,HourP,MinuteP,SecondP,Segs),
    cgLine([HourP,MinuteP,SecondP]),
    HourP^x1 #= Circle^centerX,HourP^y1 #= Circle^centerY,
    MinuteP^x1 #= Circle^centerX,MinuteP^y1 #= Circle^centerY,
    SecondP^x1 #= Circle^centerX,SecondP^y1 #= Circle^centerY,
    %
    length(Segs,60),
    cgLine(Segs),
    cgSame([HourP,MinuteP,SecondP|Segs],window,Win),
    constrainSegs(Segs,0,Circle).

% wait until Circle is packed
constrainSegs(Legs,I,Circle):-
    Circle^x #= X,
    Circle^y #= Y,
    Circle^width #= W,
    constrainSegs(Legs,I,Circle,X,Y,W).

% delay until X,Y,W are instantiated
constrainSegs(Legs,I,Circle,X,Y,W),no_vars_gt(3,0),{ins(X),ins(Y),ins(W)} => true. 
constrainSegs(Legs,I,Circle,X,Y,W) => 
    Circle^centerX #= CenterX,
    Circle^centerY #= CenterY,
    computeSegs(Legs,0,Circle,CenterX,CenterY,W).

computeSegs([],I,Circle,CenterX,CenterY,W).
computeSegs([Seg|Segs],I,Circle,CenterX,CenterY,W):-
    Angle is I*(2*pi/60),
    Radius1 is W//2,
    (I mod 5=:=0-> 
     Radius2 is Radius1*2//3;
     Radius2 is Radius1*7//8
     ),
    %
    X1 is CenterX+round(cos(Angle)*Radius1),
    Y1 is CenterY+round(sin(Angle)*Radius1),
    X2 is CenterX+round(cos(Angle)*Radius2),
    Y2 is CenterY+round(sin(Angle)*Radius2),
    Seg^x1 #= X1,
    Seg^y1 #= Y1,
     %
    Seg^x2 #= X2,
    Seg^y2 #= Y2,
     %
    I1 is I+1,
    computeSegs(Segs,I1,Circle,CenterX,CenterY,W).

constrainClocks([]).
constrainClocks([_]).
constrainClocks([C1,C2|Clocks]):-
    C1=clock(Label1,Rect1,Circle1,_,_,_),
    C2=clock(Label2,Rect2,Circle2,_,_,_),
    Label1^y #= Label2^y,
    Rect1^rightX+10 #= Rect2^x,
    Circle1^rightX+10 #= Circle2^x,
    constrainClocks([C2|Clocks]).
    
packClocks([]).
packClocks([clock(Label,Rect,Circle,Digit,Analog,Dif)|Clocks]):-
    cgPack([Label,Rect,Circle]),
    packClocks(Clocks).

showClocks([]).
showClocks([clock(Label,Rect,Circle,Digit,Analog,Dif)|Clocks]):-
    Digit=digit(Hour,Minute,Second,Sep1,Sep2),
    Analog=analog(Circle,HourP,MinuteP,SecondP,Legs),
    cgShow([Label,Rect,Circle]),
    cgShow([Hour,Minute,Second,Sep1,Sep2]),
    cgShow(Legs),
    showClocks(Clocks).

% stop ticking when Flag is instantiated
time_handler(Clocks,Timer,Flag),var(Flag),{time(Timer)} =>
    critical_region(tick_clocks(Clocks)).
time_handler(Clocks,Timer,Flag) => timer_kill(Timer).

tick_clocks([Clock|Clocks]):-
    tick_clock(Clock),
    tick_clocks(Clocks).
tick_clocks([]).

tick_clock(clock(Label,Rect,Circle,Digit,Analog,Dif)):-
    Digit=digit(Hour,Minute,Second,Sep1,Sep2),
    Analog=analog(Circle,HourP,MinuteP,SecondP,Segs),
    time(H,M,S), %get the current time
    LocalH is H-Dif,
    (LocalH<0->LocalH1 is LocalH+24;LocalH1 is LocalH),
    LocalH2 is LocalH1 mod 24,
    number_codes(LocalH2,HString), addZero(HString,HString1), 
    cgSetText(Hour,HString1),
    number_codes(M,MString), addZero(MString,MString1),
    cgSetText(Minute,MString1),
    number_codes(S,SString), addZero(SString,SString1),
    cgSetText(Second,SString1),
    Circle^width #= W,
    Circle^centerX #= CenterX,
    Circle^centerY #= CenterY,
    HAngle is 1/2*pi-(LocalH2 mod 12)*pi/6,
    HX2 is CenterX+floor(cos(HAngle)*W/5),
    HY2 is CenterY-floor(sin(HAngle)*W/5),
    HourP^x2 #:= HX2,  HourP^y2 #:= HY2, 
    %
    MAngle is 1/2*pi-(M mod 60)*pi/30,
    MX2 is CenterX+floor(cos(MAngle)*W/3),
    MY2 is CenterY-floor(sin(MAngle)*W/3),
    MinuteP^x2 #:= MX2,  MinuteP^y2 #:= MY2, 
    %
    SAngle is 1/2*pi-(S mod 60)*pi/30,
    SX2 is CenterX+floor(cos(SAngle)*W/3),
    SY2 is CenterY-floor(sin(SAngle)*W/3),
    SecondP^x2 #:= SX2,  SecondP^y2 #:= SY2,
    cgShow([HourP,MinuteP,SecondP,Hour,Minute,Second]).

addZero([D],String1):-!,String1=[0'0,D].
addZero(String,String1):-String1=String.

handleWindowClosing(Win,Flag),{windowClosing(Win)} =>
    Flag=1,
    cgClose(Win).

