/********************************************************************
    CGLIB: Constraint-based Graphical Programming in B-Prolog
    %
    animate the plan for solving the Towers of Hanoi.
*********************************************************************/
go:-
    go(3,500).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

go(N,Speed):-
    cgWindow(Win,"Towers of Hanoi"),Win^topMargin #= 30,Win^leftMargin #= 30,
    handleWindowClosing(Win),    
    createControlPanel(N,Speed,Win,CP),
    createHanoiWorld(HanoiWorld,CP),
    generateEventHandlers(CP,HanoiWorld).

generateEventHandlers(CP,HanoiWorld):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    handleReset(Reset,CP,HanoiWorld),
    handleStart(Start,CP,HanoiWorld),
    handlePause(Pause,CP,HanoiWorld),
    handleResume(Resume,CP,HanoiWorld).

handleReset(Reset,CP,HanoiWorld), {actionPerformed(Reset)} =>
    getWindow(CP,Win),
    getSize(CP,N),
    setStatus(CP,stop), % kill the executor of the plan
    getRate(CP,Rate),
    cgClose(Win),
    go(N,Rate).

handleStart(Start,CP,HanoiWorld), {actionPerformed(Start)} =>
    disableStart(CP),
    enablePause(CP),
    getRate(CP,Rate),
    disableSpeed(CP), disableSize(CP),
    setStatus(CP,running),
    hanoiPlan(HanoiWorld,Plan),
    executePlan(CP,HanoiWorld,Plan).

handlePause(Pause,CP,HanoiWorld),{actionPerformed(Pause)} =>
    enableResume(CP),
    disablePause(CP),
    setStatus(CP,waiting).

handleResume(Resume,CP,HanoiWorld),{actionPerformed(Resume)} =>
    enablePause(CP),
    disableResume(CP),
    setStatus(CP,running).

/* operations on control panel */
createControlPanel(N,Rate,Win,CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    cgLabel([LabSize,LabSpeed],["Size:","Rate:"]), 
    number_codes(N,NString),
    cgTextField(Size), Size^columns #= 5,
    cgSetText(Size,NString),
    %
    cgTextField(Speed), Speed^columns #= 5,
    number_codes(Rate,RString),
    cgSetText(Speed,RString),
    %
    cgButton([Reset,Start,Pause,Resume],["Reset","Start","Pause","Resume"]),
    Reset^height #= 20,cgSame([Reset,Start,Pause,Resume],width,40),
    Pause^x #= Win^width//2,
    % constrain the components
    cgTable([[LabSize,Size,LabSpeed,Speed],
	    [Reset,Start,Pause,Resume]],10,3),
    cgAbove(LabSize,Reset),
    %
    Comps=[LabSize,Size,LabSpeed,Speed,Reset,Start,Pause,Resume],
    cgSame(Comps,window,Win),
    cgShow(Comps),
    enableStart(CP),
    disablePause(CP),
    disableResume(CP).

getWindow(CP,Win):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status).

getSize(CP,N):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    cgGetText(Size,NString),
    catch(number_codes(N,NString),_,N=3).

getCenterX(CP,X):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    X #= (Start^rightX+Pause^x)//2.

getRate(CP,Rate):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    cgGetText(Speed,NString),
    catch(number_codes(Rate,NString),_,Rate=200).

getStatus(CP,Status):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status).

setStatus(CP,running):-!,
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    setarg(8,CP,running),
    write(post(event(EV))),nl,
    post(event(EV)). %activate the plan executor
setStatus(CP,Status):-
    setarg(8,CP,Status).

getControlPanelHeight(CP,Height):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    Height #= Size^height+Reset^height.
    
disableStart(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    disable(Start).

enableStart(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    enable(Start).

disablePause(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    disable(Pause).

enablePause(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    enable(Pause).

disableResume(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    disable(Resume).

enableResume(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    enable(Resume).

disableSpeed(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    disable(Speed).

enableSpeed(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    enable(Speed).

disableSize(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    disable(Size).

enableSize(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status),
    enable(Size).

enable(Comp):-cgSetEnabled(Comp,1), cgShow(Comp).

disable(Comp):-cgSetEnabled(Comp,0), cgShow(Comp).

/* operations on hanoi world (table, poles, disks) */
createHanoiWorld(HanoiWorld,CP):-
    HanoiWorld=hanoi(N,Disks,Poles,Table),
    getSize(CP,N),
    createTable(Table,CP),
    createPoles(Poles,Table,CP),
    createDisks(N,Disks,Poles,Table,CP),
    showHanoiWorld(HanoiWorld,CP).

createTable(Table,CP):-
    getWindow(CP,Win),
    cgRectangle(Table),Table^color #= black, Table^window #= Win,
    Table^height #= 20, Table^width #= Win^width-100,
    Table^bottomY #= Win^height-100,
    getCenterX(CP,CX),
    Table^centerX #= CX.

createPoles(Poles,Table,CP):-
    Poles=poles(pole(P1,TopY1),pole(P2,TopY2),pole(P3,TopY3)),
    PoleRects = [P1,P2,P3],
    cgRectangle(PoleRects), 
    getWindow(CP,Win), cgSame(PoleRects,window,Win),
    cgSame(PoleRects,color,red),
    Width #= Table^width//20,
    getControlPanelHeight(CP,CPHeight),
    Height #= Win^height-Win^topMargin-CPHeight-Table^height-120,
    cgSame(PoleRects,width,Width),
    cgSame(PoleRects,height,Height),
    PoleY #= Win^topMargin+CPHeight+20,
    cgSame(PoleRects,y,PoleY), 
    P2^centerX #= Table^centerX,
    P1^centerX #= P2^centerX-Table^width//4,
    P3^centerX #= P2^centerX+Table^width//4.
    
createDisks(N,Disks,poles(pole(P1,TopY1),pole(P2,TopY2),pole(P3,TopY3)),Table,CP):-
    new_array(Disks,[N]),
    DiskHeight #= P1^height//(N+1),
    Table^y-DiskHeight #= Y,
    P1^centerX #= X,
    SmallestDiskWidth #= 2*P1^width,
    LargestDiskWidth #= Table^width//4,
    Diff #= (LargestDiskWidth-SmallestDiskWidth)//N,
    getWindow(CP,Win),
    createDisks(N,Disks,DiskHeight,LargestDiskWidth,Diff,X,Y,Win),
    Disks^[1] @= Disk1,
    TopY1 #= Disk1^y,
    TopY2 #= Table^y,
    TopY3 #= Table^y.

createDisks(N,Disks,DiskHeight,DiskWidth,Diff,X,Y,Win):-N<1,!.
createDisks(N,Disks,DiskHeight,DiskWidth,Diff,X,Y,Win):-
    Disks^[N] @= Disk, % no, pole no, and comp
    cgRectangle(Disk),Disk^width#=DiskWidth, Disk^height #= DiskHeight,
    Disk^window #= Win,
    Disk^color #= gray,
    Disk^centerX #= X,
    Disk^y #= Y,
    NextY #= Y-DiskHeight,
    NextDiskWidth #= DiskWidth-Diff,
    N1 is N-1,
    createDisks(N1,Disks,DiskHeight,NextDiskWidth,Diff,X,NextY,Win).
    
showHanoiWorld(HW,CP):-
    HW=hanoi(N,Disks,poles(pole(P1,_),pole(P2,_),pole(P3,_)),Table),
    array_to_list(Disks,Comps),
    AllComps=[Table,P1,P2,P3|Comps],
    cgShow(AllComps).

%% find a plan
hanoiPlan(hanoi(N,Disks,Poles,Table),Plan):-
    hanoiPlan(N,1,3,2,Plan,[]).

hanoiPlan(0,P1,P2,P3,Plan,PlanR):-!,Plan=PlanR.
hanoiPlan(N,P1,P2,P3,Plan,PlanR):-
    N1 is N-1,
    hanoiPlan(N1,P1,P3,P2,Plan,Plan1),
    Plan1 = [move(N,P1,P2)|Plan2],
    hanoiPlan(N1,P3,P2,P1,Plan2,PlanR).

%% execute a plan
executePlan(CP,HanoiWorld,[Step|Plan]):-
    getStatus(CP,running),!,
    executeStep(HanoiWorld,Step),
    getRate(CP,Time),
    cgSleep(Time),
    executePlan(CP,HanoiWorld,Plan).
executePlan(CP,HanoiWorld,Plan):-
    getStatus(CP,waiting),!,
    sleep(500),
    executePlan(CP,HanoiWorld,Plan).
executePlan(CP,HanoiWorld,_):-
    disablePause(CP). %come here when Plan is empty or Status is "stop"
	   
% from Pole 1 to Pole 2
executeStep(HanoiWorld,move(I,Pno1,Pno2)):-
    HanoiWorld=hanoi(_,Disks,Poles,Table),
    Disks^[I] @= Disk,
    arg(Pno1,Poles,Pole1), Pole1=pole(Rect1,TopY1),
    arg(Pno2,Poles,Pole2), Pole2=pole(Rect2,TopY2),
    NewX #= Rect2^centerX-Disk^width//2,
    NewY #= TopY2-Disk^height,
    cgClean(Disk),
    Disk^x #:= NewX,
    Disk^y #:= NewY,
    NewTopY1 #= TopY1+Disk^height,
    setarg(2,Pole1,NewTopY1),
    setarg(2,Pole2,NewY),
    cgShow(Disk).

