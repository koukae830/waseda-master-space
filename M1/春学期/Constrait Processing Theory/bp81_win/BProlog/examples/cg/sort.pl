/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    animate the selection sort algorithm
*********************************************************************/
go:-
    anim_sort(20).

anim_sort(N):-
    anim_sort(N,200).

anim_sort(N,Speed):-
    cgWindow(Win,"Animating the Selection Sort Algorithm"),Win^topMargin #= 30,Win^leftMargin #= 30,
    createControlPanel(N,Speed,Win,CP),
    generateAndShowData(CP,Data),
    generateEventHandlers(CP,Data),
    handleWindowClosing(Win).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

generateEventHandlers(CP,Data):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    inputSize(Size,CP),
    inputRate(Speed,CP),
    handleReset(Reset,CP,Data),
    handleStart(Start,CP,Data),
    handlePause(Pause,CP,Data),
    handleResume(Resume,CP,Data).

inputSize(Size,CP),{keyTyped(Size,_)} => disableStart(CP).

inputRate(Rate,CP),{keyTyped(Rate,_)} => disableStart(CP).

handleReset(Reset,CP,Data), {actionPerformed(Reset)} =>
    getWindow(CP,Win),
    getSize(CP,N),
    setStatus(CP,stop), % kill the sorting agent
    getRate(CP,Rate),
    cgClose(Win),
    anim_sort(N,Rate).

handleStart(Start,CP,Data), {actionPerformed(Start)} =>
    disableStart(CP),
    enablePause(CP),
    getRate(CP,Rate),
    getSize(CP,N),
    disableSpeed(CP), disableSize(CP),
    setStatus(CP,running),
    selectionSort(CP,Data,1,N).

handlePause(Pause,CP,Data),{actionPerformed(Pause)} =>
    enableResume(CP),
    disablePause(CP),
    setStatus(CP,waiting).

handleResume(Resume,CP,Data),{actionPerformed(Resume)} =>
    enablePause(CP),
    disableResume(CP),
    setStatus(CP,running).

/* operations on control panel */
createControlPanel(N,Rate,Win,CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    cgLabel([LabSize,LabSpeed],["Size:","Rate:"]), 
    number_codes(N,NString),
    cgTextField(Size), 
%    cgSetColumns([Size,Speed],5),
    cgSetText(Size,NString),
    %
    cgTextField(Speed), 
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
    disablePause(CP),
    disableResume(CP).

getWindow(CP,Win):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV).

getSize(CP,N):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    cgGetText(Size,NString),
    catch(number_codes(N,NString),_,N=3).

getCenterX(CP,X):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    X #= (Start^rightX+Pause^x)//2.

getRate(CP,Rate):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    cgGetText(Speed,NString),
    catch(number_codes(Rate,NString),_,Rate=200).

getStatus(CP,Status):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV).

setStatus(CP,running):-!,
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    setarg(8,CP,running),
    post(event(EV)). %activate the plan executor
setStatus(CP,Status):-
    setarg(8,CP,Status).

getControlPanelHeight(CP,Height):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    Height #= Size^height+Reset^height.
    
disableStart(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    disable(Start).

enableStart(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    enable(Start).

disablePause(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    disable(Pause).

enablePause(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    enable(Pause).

disableResume(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    disable(Resume).

enableResume(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    enable(Resume).

disableSpeed(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    disable(Speed).

enableSpeed(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    enable(Speed).

disableSize(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    disable(Size).

enableSize(CP):-
    CP=cp(Win,Size,Speed,Reset,Start,Pause,Resume,Status,EV),
    enable(Size).

enable(Comp):-cgSetEnabled(Comp,1), cgShow(Comp).

disable(Comp):-cgSetEnabled(Comp,0), cgShow(Comp).

%%
generateAndShowData(CP,Data):-
    getSize(CP,N),
    getWindow(CP,Win),
    getControlPanelHeight(CP,CpHeight),
    new_array(Data,[N]),
    Height #= (Win^height-Win^topMargin-CpHeight-20)//(N+4)-3,
    Y0 #= Win^topMargin+CpHeight+10,
    generateRandomArray(Data,Labs,Recs,1,N,Win,Y0,Height), % for each random number, generate a label and a rectangle
    cgLeft(Labs,Recs),
    cgShow(Labs),cgShow(Recs),
    enableStart(CP).

generateRandomArray(Data,Labs,Recs,N0,N,Win,Y,Height):-N0>N,!,Labs=[],Recs=[].
generateRandomArray(Data,Labs,Recs,N0,N,Win,Y,Height):-
    IntNum is round(abs(random)) mod 450+1,
    cgRectangle(Rec), Rec^width #= IntNum,Rec^window #= Win,
    number_codes(IntNum,NumString),
    cgString(Lab,NumString),
    cgTable([[Lab,Rec]]),
    Lab^height #= Height, Lab^y #= Y,
    Lab^window #= Win,
    Data^[N0] @= elm(IntNum,Lab,Rec),
    Labs=[Lab|Labs1], Recs=[Rec|Recs1],
    N1 is N0+1,
    Y1 #= Y+Height+3,
    generateRandomArray(Data,Labs1,Recs1,N1,N,Win,Y1,Height).

%%
selectionSort(CP,Data,N0,N),
    cp(Win,Size,Speed,Reset,Start,Pause,Resume,waiting,EV)=CP,
    {event(EV)}
    =>
    true.  %wait until Resume is clicked
selectionSort(CP,Data,N0,N),N0<N,
    cp(Win,Size,Speed,Reset,Start,Pause,Resume,running,EV)=CP
    =>
    N1 is N0+1,
    Data^[N0] @= elm(Min0,_,_),
    selectMin(Data,N1,N,Min0,N0,I),
    swapAndShow(CP,Data,N0,I),
    selectionSort(CP,Data,N1,N).
selectionSort(CP,Data,N0,N),N0=:=N => setColor(Data,N,red),disablePause(CP).
selectionSort(CP,Data,N0,N) => true. %come here if Status is "stop"

selectMin(Data,N0,N,Min0,MinI0,I):-N0>N,!,I=MinI0.
selectMin(Data,N0,N,Min0,MinI0,I):-
    Data^[N0] @= elm(Elm,_,_),
    (Elm<Min0->
     Min1=Elm,MinI1=N0;
     Min1=Min0,MinI1=MinI0),
    N1 is N0+1,
    selectMin(Data,N1,N,Min1,MinI1,I).
     
swapAndShow(CP,Data,I,MinI):-
    setColor(Data,MinI,blue),
    getRate(CP,Time),
    cgSleep(Time),
    swapPosition(Data,I,MinI),
    setColor(Data,I,red),
    cgSleep(Time).
    
setColor(Data,I,Color):-
    Data^[I] @= elm(_,Lab,Rec),
    Lab^color #:= Color,
    Rec^color #:= Color,
    cgShow([Lab,Rec]).

swapPosition(Data,I,J):-
    Data^[I] @= Ai, Ai=elm(Elmi,Labi,Reci),
    Data^[J] @= Aj, Aj=elm(Elmj,Labj,Recj),
    TempYi #= Labi^y, TempYj #= Labj^y,
    Labi^y #:= TempYj, Reci^y #:= TempYj,
    Labj^y #:= TempYi, Recj^y #:= TempYi,
    Data^[I] @:= Aj,
    Data^[J] @:= Ai,
    cgShow([Labi,Reci,Labj,Recj]).



