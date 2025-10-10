/* GOLT: A tool in B-Prolog and CGLIB for inputing, reviewing, and playing GO games */
/* by Neng-Fa Zhou (C). All rights reserved                                         */
main:-
    go,
    $event_watching_loop.

go:-
    cgWindow(Window,"GOLT: A GO Learning Tool in B-Prolog"),
    % set menu
    cgMenu([File,View,Edit,Review,Help],["File","View","Edit","Review","Help"]),
    cgMenuItem([New,Load,SaveAnim,Save,SaveAs,Undo,Start,Stop,Next,Howto,Sep,Quit],["New","Load (ctl-l)","Save As Animation", "Save (ctl-s)","SaveAs","Undo (ctl-u)","Start","Stop","Next","Howto","-","Quit"]),
    cgCheckboxMenuItem(StoneNumbered, "Stones with numbers"), 
    cgSetState(StoneNumbered,1),
    cgAdd(File,[New,Load,SaveAnim,Save,SaveAs,Sep,Quit]),
    cgAdd(Edit,Undo),
    cgAdd(Review,[Start,Next]),
    cgSetEnabled(Stop,0),
    cgAdd(Help,Howto),
    cgAdd(View,StoneNumbered),
    cgMenuBar(MenuBar),
    cgSetMenuBar(Window,MenuBar),
    cgAdd(MenuBar,[File,View,Edit,Help]),
    %
    createBoard(Window,Board), % Board=board(Window,Indicator,GridSize,BoardState,FileName,NextTurn,Steps,Kou,Jails,CP).
    handleWindowClosing(Window),
    handleNew(New,Board),
    handleSaveAnim(SaveAnim,Board),
    handleSaveItem(Save,Board),
    handleKeyEvents([Window],Board),
    handleSaveAs(SaveAs,Board),
    handleLoadItem(Load,Board),
    handleUndoItem(Undo,Board),
    handleStoneSelection(StoneNumbered),
    handleHelp(Howto),
    handleMove(Window,Board),
    handleQuit(Quit),
    critical_region(drawBoard(Board)),
    handleWindowResized(Window,Board).

%% Event handlers
%%triggered when the menu item StoneNumbered is selected
handleStoneSelection(StoneNumbered),{itemStateChanged(StoneNumbered,E)} =>
    cgGetState(StoneNumbered,State),
    (State==1->global_set(stone_type,0,numbered);
     global_set(stone_type,0,unnumbered)).

% triggered when window is resized
handleWindowClosing(Window),{windowClosing(Window)} => cgClose(Window).

handleQuit(Quit),{actionPerformed(Quit)} => abort.

handleWindowResized(Window,Board),{componentResized(Window,E)} => 
    Window^width #= W,
    Window^height #= H,
    (W<H -> WinSize is W; WinSize is H),
    resize(Board,WinSize).

% start a new game
handleNew(New,Board),{actionPerformed(New)} =>
    newGame(Board).

newGame(Board):-
    initializeBoard(Board),
    setFileName(Board,nil),
    redrawBoard(Board,0).

% save the current game, waiting for 2 seconds each step.
handleSaveAnim(SaveAnim,Board),{actionPerformed(SaveAnim)} =>
    critical_region(saveGameAsAnimation(Board)).

% save the game either by selecting Save item or typing control-s
handleSaveItem(Save,Board),{actionPerformed(Save)} =>
    critical_region(saveGame(Board)).

handleControlS(Window,Board),{keyPressed(Window,E)} =>
    E^code #= Code,
    ((cgControlIsDown(E),
      vk_S(Code)) -> saveGame(Board);true).

handleSaveAs(SaveAs,Board),{actionPerformed(SaveAs)} =>
      saveGameAs(Board).

handleLoadItem(Load,Board),{actionPerformed(Load)} => critical_region(loadGame(Board)).

handleControlL(Window,Board),{keyPressed(Window,E)} => /* control-l */
    E^code #= Code,
    ((cgControlIsDown(E),
      vk_L(Code)) -> critical_region(loadGame(Board));true).

handleMove(Window,Board),{mousePressed(Window,E)} =>
    (getGameMode(Board,input)->
     E^x #= X, E^y #= Y,
     critical_region(placeStone(Board,X,Y));true).

handleInputUndoSteps(Comp,Board),{keyTyped(Comp,E)} =>
    E^char #= D,
    char_code(D,DCode),
    (global_get(undo_steps,0,N) ->true; N=0),
    ((DCode>=0'0,DCode=<0'9)->
     N1 is N*10+DCode-0'0,
     global_set(undo_steps,0,N1);true).

handleUndoItem(Undo,Board),{actionPerformed(Undo)} => undo(Board).

handleControlU(Comp,Board),{keyPressed(Comp,E)} =>
    E^code #= Code,
   (cgControlIsDown(E),
    vk_U(Code))-> undo(Board);true.
   
undo(Board):-
    (getGameMode(Board,input)->critical_region(undoAux(Board));true).

undoAux(Board):-
    (global_get(undo_steps,0,N)->true;N=1), %undo one step if the number of steps is not given
    global_del(undo_steps,0),
    length(UndoSteps,N),
    getSteps(Board,AllSteps),
    (append(UndoSteps,RemainSteps,AllSteps)->true;RemainSteps=[]),
    setSteps(Board,RemainSteps),
    redrawBoard(Board,0).

handleStart(Start,Stop,Board), {actionPerformed(Start)} => true.

handleHelp(Howto),{actionPerformed(Howto)} =>
    cgWindow(Win,"GOLT: How to"), Win^topMargin #= 30,
    cgTextArea(TA), TA^window #= Win,
    igo_howto(Text),
    cgSetText(TA,Text), TA^width #= Win^width, TA^height #= Win^height-100, TA^fontSize #= 14,
    handleCloseHowto(Win),
    cgShow(TA).

handleReview(CP,Board),
    cp(StartReview,StopReview,Next,Mode)=CP, {actionPerformed(StartReview)} =>
    setarg(4,CP,review),
    getSteps(Board,Steps),
    handleStop(CP,StopSign,Board,Steps),
    redrawBoard(Board,[],0),
    reverse(Steps,ReSteps),
    cgSetEnabled(StartReview,0),
    cgSetEnabled(StopReview,1),
    cgSetEnabled(Next,1),
    cgShow([StartReview,StopReview,Next]),
    reviewNextStep(Next,StopSign,steps(ReSteps),Board).

reviewNextStep(Next,StopSign,Steps,Board),var(StopSign),steps([s(X,Y)|Rest])=Steps,{actionPerformed(Next)} =>
    addStone(Board,X,Y),
    setarg(1,Steps,Rest).
reviewNextStep(Next,StopSign,Steps,Board)=>getControlPanel(Board,CP),stopReview(CP).
    
handleStop(CP,StopSign,Board,Steps),
    cp(StartReview,StopReview,Next,Mode)=CP,
    {actionPerformed(StopReview)} =>
    StopSign=1,
    setSteps(Board,Steps),
    stopReview(CP).

stopReview(CP):-
    cp(StartReview,StopReview,Next,Mode)=CP,
    cgSetEnabled(StartReview,1), 
    cgSetEnabled([StopReview,Next],0),
    cgShow([StartReview,StopReview,Next]),
    setarg(4,CP,input).
    
handleCloseHowto(Win),{windowClosing(Win)} => cgClose(Win).

igo_howto(Text):-
    Text = "GOLT is a GO learning tool developed in B-Prolog and CGLIB. It enables the user to input and review games. \c
     After GOLT is started, it is ready to input a new game.  \c
     \c
     To see this help window, select Help->Howto. \c
     To save a game, select File->Save or File->SaveAs or simply type ctl-s. \c
     To load a game, select File->Load or simply type ctl-l. \c
     To undo a step, select Edit->Undo or simply type ctl-u. \c
     To review a game, click on the Review button. The viewer can view a game as a movie and can review a game step by step. ".

% indicator of the next move
createIndicator(Window,Indicator):- % mark the intersection before the user places a stone
    cgCircle(Indicator),Indicator^color #= gray, Indicator^fill #= 0, 
    Indicator^window #= Window.

showIndicator(Board,Row,Col):-
    getIndicator(Board,Indicator),
    computeIntersectPosition(Board,Row,Col,X,Y),
    Indicator^x #= OldX,
    Indicator^y #= OldY,
    (OldX==X,OldY==Y->true;
     Indicator^x #:= X, % update the position of the indicator
     Indicator^y #:= Y,
     cgShow(Indicator)).

cleanIndicator(Board):- % erase the indicator when mouse is out of the board of an operation is being applied
   getIndicator(Board,Indicator),
   cgSetVisible(Indicator,0).

/* show the position of the next move */
% moveIndicator(Window,Board).
moveIndicator(Window,Board),{mouseMoved(Window,E)} =>
    E^x #= X,
    E^y #= Y,
    (feasiblePosition(Board,X,Y,Row,Col)-> % s(Row,Col) is an intersection 
     showIndicator(Board,Row,Col);
     cleanIndicator(Board)).

%% board and  operations on it
createBoard(Window,Board):-
    GridSize = 30,
    WinSize = 100+30*24,
    Window^width #= WinSize, Window^height #= WinSize,
    FileName=nil,
    new_array(BoardState,[19,19]),
    StepNo = 1,
    Steps=[],
    createControlPanel(CP,Board),
    createIndicator(Window,Indicator),
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,kou,Jails,CP),
    createJails(Window,Jails),
    initializeBoardState(Board),
    moveIndicator(Window,Board),
    handleReview(CP,Board).

createControlPanel(CP,Board):-
    CP=cp(StartReview,StopReview,Next,input), % initial mode is input
    Buttons=[StartReview,StopReview,Next],
    cgButton(Buttons,["Start Review", "Stop Review", "Next"]),
    cgSetEnabled(StartReview,1),
    cgSetEnabled([StopReview,Next],0),
    cgSame(Buttons,fontSize,16),
    handleKeyEvents(Buttons,Board).

handleKeyEvents([],Board).
handleKeyEvents([B|Bs],Board):-
    handleInputUndoSteps(B,Board),
    handleControlU(B,Board),
    handleControlS(B,Board),
    handleControlL(B,Board),
    handleKeyEvents(Bs,Board).

createJails(Window,Jails):- 
    Jails=jails(BJail,WJail),
    BJail=jail(0,BLab,BCount),
    WJail=jail(0,WLab,WCount),
    cgString([BLab,BCount,WLab,WCount],["Black:","0","White:","0"]),
    cgSame([BLab,BCount,WLab,WCount],window,Window).

addPrisoners(Board,Color,P):-
     Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
     Jails=jails(BJail,WJail),
     (Color == black -> Jail=BJail;Jail=WJail),
     Jail=jail(N,Lab,Count),
     NewN is N+P,
     setarg(1,Jail,NewN),
     number_codes(NewN,String),
     cgSetText(Count,String),
     cgShow(Count).

initializeJails(Board):-
   Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
   Jails=jails(BJail,WJail),
   BJail=jail(B,BLab,BCount),
   setarg(1,BJail,0),cgSetText(BCount,"0"),
   WJail=jail(W,WLab,WCount),
   setarg(1,WJail,0),cgSetText(WCount,"0").

initializeBoard(Board):-
    setSteps(Board,[]),
    setStepNo(Board,1),
    initializeControlPanel(Board),
    initializeJails(Board),
    setKou(Board,nil),
    setGameMode(Board,input),
    initializeBoardState(Board).

initializeControlPanel(Board):-
    getControlPanel(Board,CP),
    CP=cp(StartReview,StopReview,Next,Mode),
    cgSetEnabled(StartReview,1),
    cgSetEnabled([StopReview,Next],0),
    cgShow([StartReview,StopReview,Next]).

initializeBoardState(Board):-
    getBoardState(Board,BoardState),
    initializeBoardState1(BoardState,1).

initializeBoardState1(A,I):-I>19,!.
initializeBoardState1(A,I):-
    initializeBoardState2(A,I,1),
    I1 is I+1,
    initializeBoardState1(A,I1).

initializeBoardState2(A,I,J):-J>19,!.
initializeBoardState2(A,I,J):-
    A^[I,J] @:= nil,
    J1 is J+1,
    initializeBoardState2(A,I,J1).

getWindow(Board,Window):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

getIndicator(Board,Indicator):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

getGridSize(Board,GridSize):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

getBoardState(Board,BoardState):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

setGridSize(Board,GridSize):-
   setarg(3,Board,GridSize).

getFileName(Board,FileName):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

setFileName(Board,FileName):-
    setarg(5,Board,FileName).

setGameMode(Board,Mode):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
    setarg(4,CP,MOde).

getGameMode(Board,Mode):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
    CP=cp(StartReview,StopReview,Next,Mode).

getStepNo(Board,StepNo):-
     Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

setStepNo(Board,StepNo):-
     setarg(6,Board,StepNo).

incrementStepNo(Board):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
    NewStepNo is StepNo+1,
    setarg(6,Board,NewStepNo).

getColor(Board,Color):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
    (StepNo mod 2=:= 0 -> Color=white; Color=black).

getSteps(Board,Steps):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

getControlPanel(Board,CP):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

setSteps(Board,Steps):-
    setarg(7,Board,Steps).

addStep(Board,Step):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
    setarg(7,Board,[Step|Steps]).

getKou(Board,Kou):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP).

setKou(Board,Kou):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),!.
setKou(Board,Kou):-
    setarg(8,Board,Kou).

computeIntersectPosition(Board,Row,Col,X,Y):-
    Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
    X is 100+(Col-1)*GridSize+GridSize//2,
    Y is 100+(Row-1)*GridSize+GridSize//2.

%apply operations on board
%% window resized
resize(Board,WinSize):-
    GridSize is (WinSize-100)//24,
    setGridSize(Board,GridSize),
    getIndicator(Board,Indicator),
    Indicator^width #:= GridSize,
    Indicator^height #:= GridSize,
    redrawBoard(Board,0).

%% place a stone to the intersection at <X,Y> if that position is feasible
placeStone(Board,X,Y):-
    feasiblePosition(Board,X,Y,Row,Col),!,
    addStone(Board,Row,Col).
placeStone(Board,X,Y).

feasiblePosition(Board,X,Y,Row,Col):- % to be completed
    getGridSize(Board,GridSize),
    X>100+GridSize/2, X<100+GridSize*19+GridSize/2,  % left-upper location (100,100)
    Y>100+GridSize/2, Y<100+GridSize*19+GridSize/2, 
    Col is round((X-100)/GridSize),
    Row is round((Y-100)/GridSize),
    Row>=1, Row=< 19,
    Col>=1, Col=< 19,
    getBoardState(Board,State),
    getColor(Board,Color),
    not occupied(State,Row,Col),
    getKou(Board,KouMe),
    not getKou(Board,(Row,Col)),
    (hasLiberty(State,Color,Row,Col);
     captureSituation(State,Color,Row,Col)),!.

occupied(State,Row,Col):-
    State^[Row,Col] @= stone(_,_,_).

hasLiberty(State,Color,Row,Col):-
   new_array(Visited,[19,19]),
   Visited^[Row,Col] @= 1,
    (Row1 is Row-1, Row1>=1, unitHasLiberty(State,Visited,Color,Row1,Col);
    Row1 is Row+1, Row1=<19, unitHasLiberty(State,Visited,Color,Row1,Col);
    Col1 is Col-1, Col1>=1, unitHasLiberty(State,Visited,Color,Row,Col1);
    Col1 is Col+1, Col1=<19, unitHasLiberty(State,Visited,Color,Row,Col1)),!.

unitHasLiberty(State,Visited,Color,Row,Col):-
   State^[Row,Col] @= nil,!.
unitHasLiberty(State,Visited,Color,Row,Col):-
   State^[Row,Col] @= stone(Color,_,_),
   (unitHasNoLiberty(State,Visited,Color,Row,Col,0,_)->fail;true).

%% one of the oposite units starting from <Row,Col> has no liberty after <Row,Col> is taken by Color
captureSituation(State,Color,Row,Col):-
    new_array(Visited,[19,19]),
    Visited^[Row,Col] @= 1,
    oposite(Color,OpColor),
   (Row1 is Row-1, Row1>=1, State^[Row1,Col] @= stone(OpColor,_,_),unitHasNoLiberty(State,Visited,OpColor,Row1,Col,0,US),US>0;
    Row1 is Row+1, Row1=<19,State^[Row1,Col] @= stone(OpColor,_,_),unitHasNoLiberty(State,Visited,OpColor,Row1,Col,0,US),US>0;
    Col1 is Col-1, Col1 >= 1,State^[Row,Col1] @= stone(OpColor,_,_),unitHasNoLiberty(State,Visited,OpColor,Row,Col1,0,US),US>0;
    Col1 is Col+1, Col1 =< 19,State^[Row,Col1] @= stone(OpColor,_,_),unitHasNoLiberty(State,Visited,OpColor,Row,Col1,0,US),US>0),!.

unitHasNoLiberty(State,Visited,Color,Row,Col,US0,US):- %US-- Unite Size
    Visited^[Row,Col] @= V,nonvar(V), !,US0=US.
unitHasNoLiberty(State,Visited,Color,Row,Col,US0,US):-
    State^[Row,Col] @= stone(Color,_,_),!, 
    Visited^[Row,Col] @=1,
    Row1 is Row-1,
    Row2 is Row+1,
    Col1 is Col-1,
    Col2 is Col+1,
    US1 is US0+1,
    (Row1>=1->unitHasNoLiberty(State,Visited,Color,Row1,Col,US1,US2);US1=US2),
    (Row2=<19->unitHasNoLiberty(State,Visited,Color,Row2,Col,US2,US3);US3=US2),
    (Col1>=1->unitHasNoLiberty(State,Visited,Color,Row,Col1,US3,US4);US4=US3),
    (Col2=<19->unitHasNoLiberty(State,Visited,Color,Row,Col2,US4,US);US=US4).
unitHasNoLiberty(State,Visited,Color,Row,Col,US0,US):-
    State^[Row,Col] @= stone(OpColor,_,_),!,US=US0.
   
% add a stone 
addStone(Board,Row,Col):-
    addStep(Board,s(Row,Col)),
    getWindow(Board,Window),
    getColor(Board,Color),
    getGridSize(Board,GridSize),
    computeIntersectPosition(Board,Row,Col,X,Y),			  
    cgCircle(Stone),
    Stone^width #= GridSize, 
    Stone^x #= X,
    Stone^y #= Y,
    getStepNo(Board,StepNo), number_codes(StepNo,StepNoStr),
    cgString(Lab,StepNoStr),
    computeFontSize(StepNo,GridSize,FontSize),
    Lab^fontSize #= FontSize,
    cgSetAlignment(Lab,center),
    (StepNo mod 2 =:= 1 -> Color=black; Color=white),oposite(Color,OpColor),
    Stone^color #= Color,
    Lab^color #= OpColor,
    cgSame([Stone,Lab],center), cgSame([Stone,Lab],window,Window),
    (global_get(stone_type,0,unnumbered)->
       cgShow(Stone);
       cgShow([Stone,Lab])),
    updateBoardState(stone(Color,Stone,Lab),Board,Row,Col),
    incrementStepNo(Board).

updateBoardState(Stone,Board,Row,Col):-Stone=stone(Color,_,_),
    getBoardState(Board,State),
    capture(State,Color,Row,Col,US,Where),
    addPrisoners(Board,Color,US),
    State^[Row,Col] @:= Stone,
    (isKouSituation(State,Color,Row,Col,US,Where,KouRow,KouCol)-> Kou=(KouRow,KouCol); Kou=nil),
    setKou(Board,Kou).

isKouSituation(State,Color,Row,Col,US,Where,KouRow,KouCol):-
   US=:=1,
   kouPosition(Where,Row,Col,KouRow,KouCol),
   Row1 is Row-1,
   Row2 is Row+1,
   Col1 is Col-1,
   Col2 is Col+1,
   oposite(Color,OpCOlor),
   (Row1 >=1 -> (State^[Row1,Col] @= stone(OpColor,_,_);Row1=:=KouRow,Col=:=KouCol);true),
   (Row2=<19 -> (State^[Row2,Col] @= stone(OpColor,_,_);Row2=:=KouRow,Col=:=KouCol);true),
   (Col1>=1 ->  (State^[Row,Col1] @= stone(OpColor,_,_);Row=:=KouRow,Col1=:=KouCol);true),
   (Col2=<19 -> (State^[Row,Col2] @= stone(OpColor,_,_);Row=:=KouRow,Col2=:=KouCol);true).

kouPosition(1,Row,Col,KouRow,KouCol):-KouRow is Row-1,KouCol=Col.
kouPosition(2,Row,Col,KouRow,KouCol):-KouRow is Row+1,KouCol=Col.
kouPosition(3,Row,Col,KouRow,KouCol):-KouRow is Row,KouCol is Col-1.
kouPosition(4,Row,Col,KouRow,KouCol):-KouRow is Row,KouCol is Col+1.
    
capture(State,Color,Row,Col,US,Where):-
    new_array(Visited,[19,19]),
    Visited^[Row,Col] @= 1,
    oposite(Color,OpColor),
    %
    capture1(State,Visited,OpColor,Row,Col,US1), (US1>=1 -> Where=1;true),
    capture2(State,Visited,OpColor,Row,Col,US2), ((US2>=1,var(Where)) -> Where=2;true),
    capture3(State,Visited,OpColor,Row,Col,US3), ((US3>=1,var(Where)) -> Where=3;true),
    capture4(State,Visited,OpColor,Row,Col,US4), ((US4>=1,var(Where)) -> Where=4;true),
    US is US1+US2+US3+US4.

capture1(State,Visited,Color,Row,Col,US):- %up unit
    Row1 is Row-1,
    Row1>=1,
    State^[Row1,Col] @= stone(Color,_,_), 
    unitHasNoLiberty(State,Visited,Color,Row1,Col,0,US),!,
    captureUnit(State,Color,Row1,Col).
capture1(State,Visited,Color,Row,Col,US):-US=0.

capture2(State,Visited,Color,Row,Col,US):- %below unit
    Row1 is Row+1,
    Row1=<19,
    State^[Row1,Col] @= stone(Color,_,_), 
    unitHasNoLiberty(State,Visited,Color,Row1,Col,0,US),!,
    captureUnit(State,Color,Row1,Col).
capture2(State,Visited,Color,Row,Col,US):-US=0.

capture3(State,Visited,Color,Row,Col,US):- %left unit
    Col1 is Col-1,
    Col1>=1,
    State^[Row,Col1] @= stone(Color,_,_), 
    unitHasNoLiberty(State,Visited,Color,Row,Col1,0,US),!,
    captureUnit(State,Color,Row,Col1).
capture3(State,Visited,Color,Row,Col,US):-US=0.

capture4(State,Visited,Color,Row,Col,US):- %right unit
    Col1 is Col+1,
    Col1=<19,
    State^[Row,Col1] @= stone(Color,_,_), 
    unitHasNoLiberty(State,Visited,Color,Row,Col1,0,US),!,
    captureUnit(State,Color,Row,Col1).
capture4(State,Visited,Color,Row,Col,US):-US=0.

captureUnit(State,Color,Row,Col):-
   State^[Row,Col] @= stone(Color,Stone,Lab), !,
   State^[Row,Col] @:= nil,
   cgSetVisible(Stone,0),cgSetVisible(Lab,0),
   captureUnit1(State,Color,Row,Col),
   captureUnit2(State,Color,Row,Col),
   captureUnit3(State,Color,Row,Col),
   captureUnit4(State,Color,Row,Col).
captureUnit(State,Color,Row,Col).

captureUnit1(State,Color,Row,Col):- %up unit
    Row1 is Row-1,
    Row1>=1,!,
    captureUnit(State,Color,Row1,Col).
captureUnit1(State,Color,Row,Col).

captureUnit2(State,Color,Row,Col):- %below unit
    Row1 is Row+1,
    Row1=<19,!,
    captureUnit(State,Color,Row1,Col).
captureUnit2(State,Color,Row,Col).

captureUnit3(State,Color,Row,Col):- %left unit
    Col1 is Col-1,
    Col1>=1,!,
    captureUnit(State,Color,Row,Col1).
captureUnit3(State,Color,Row,Col).

captureUnit4(State,Color,Row,Col):- %right unit
    Col1 is Col+1,
    Col1=<19,!,
    captureUnit(State,Color,Row,Col1).
captureUnit4(State,Color,Row,Col).

computeFontSize(StepNo,GridSize,FontSize):-StepNo<10,!,FontSize is round(GridSize*0.9).
computeFontSize(StepNo,GridSize,FontSize):-StepNo<100,!,FontSize is round(GridSize/1.6).
computeFontSize(StepNo,GridSize,FontSize):-!,FontSize is round(GridSize/2.1).

/* redraw the board and the steps made by now when window is resized */
redrawBoard(Board,SleepTime):-
     getSteps(Board,Steps),
     redrawBoard(Board,Steps,SleepTime).

redrawBoard(Board,Steps,SleepTime):-
     drawBoard(Board),
     initializeBoard(Board),
     reverse(Steps,ReSteps),
     addStones(Board,ReSteps,SleepTime).

addStones(Board,[],SleepTime).
addStones(Board,[s(Row,Col)|Steps],SleepTime):-
     addStone(Board,Row,Col),
     cgSleep(SleepTime),
     addStones(Board,Steps,SleepTime).

/* draw the 19*19 GO board */
goBoard(N,Window,Comps):-
     cgColor(GoColor),GoColor^red #= 220, GoColor^green #= 160, GoColor^blue #= 0, % wood color
     cgSquare(Frame),Frame^color #= GoColor,
     GridSize=30,
     BoardSize is GridSize*(N+1),
     Frame^width #= BoardSize,
     Frame^x #= 100, Frame^y #= 100,
     Frame^window #= Window,
     drawLines(Window,100,100,GridSize,N,Lines),
     drawStar(Window,100,100,GridSize,N,Stars),
     append(Lines,Stars,LinesStars),
     Comps=[Frame|LinesStars].

drawBoard(Board):-
     Board=board(Window,Indicator,GridSize,BoardState,FileName,StepNo,Steps,Kou,Jails,CP),
     cgCleanDrawing(Window), Window^topMargin #= 50,
     cgColor(GoColor),GoColor^red #= 220, GoColor^green #= 160, GoColor^blue #= 0, % wood color
     %
     cgSquare(Frame),Frame^color #= GoColor,
     BoardSize is GridSize*20,
     Frame^width #= BoardSize,
     Frame^x #= 100, Frame^y #= 100,
     Frame^window #= Window,
     cgShow(Frame),
     %
     drawControlPanel(Window,Frame,CP),
     drawLines(Window,100,100,GridSize,19,Lines),
     cgShow(Lines),
     drawStar(Window,100,100,GridSize,19,Stars),
     cgShow(Stars),
     drawPrisoners(Jails,BoardSize).

drawControlPanel(Window,Frame,CP):-
    CP=cp(StartReview,StopReview,Next,Mode),
    cgSame([StartReview,StopReview,Next],window,Window),
    cgLabel([L1,L2,L3],["StartReview","StopReview","Next"]),
    L1^y #>=50,
    cgSame([L1,L2,L3],fontSize,16),
    cgTable([[L1,L2,L3]],10,10),
    cgSame([L2,Frame],centerX),
    cgAbove(L1,Frame),
    cgPack([L1,L2,L3]),
    getComponentBound(L1,X,Y,W,H),
    setSizeLocation(StartReview,L1),
    setSizeLocation(StopReview,L2),
    setSizeLocation(Next,L3),
    cgShow([StartReview,StopReview,Next]).

setSizeLocation(O1,O2):-
    O1^x #:= O2^x, O1^y #:= O2^y, O1^width #:= O2^width, O1^height #:= O2^height.

drawLines(Window,X0,Y0,GridSize,N,Lines):-
    X1 is X0+GridSize,
    Y1 is Y0+GridSize,
    Xn is X0+GridSize*N,
    drawHorizontalLines(X1,Y1,Xn,GridSize,N,Lines,Lines1),
    Yn is Y0+GridSize*N,
    drawVerticalLines(X1,Y1,Yn,GridSize,N,Lines1,[]),
    cgSame(Lines,window,Window).
    
drawHorizontalLines(X1,Y1,Xn,GridSize,N,Lines,LinesR):-N=:=0,!,Lines=LinesR.
drawHorizontalLines(X1,Y1,Xn,GridSize,N,Lines,LinesR):-
    Lines=[L|Lines1],
    cgLine(L),
    L^x1 #= X1,L^y1 #= Y1,
    L^x2 #= Xn, L^y2 #= Y1,
    NextY is Y1+GridSize,
    N1 is N-1,
    drawHorizontalLines(X1,NextY,Xn,GridSize,N1,Lines1,LinesR).

drawVerticalLines(X1,Y1,Yn,GridSize,N,Lines,LinesR):-N=:=0,!,Lines=LinesR.
drawVerticalLines(X1,Y1,Yn,GridSize,N,Lines,LinesR):-
    Lines=[L|Lines1],
    cgLine(L),
    L^x1 #= X1,L^y1 #= Y1,
    L^x2 #= X1, L^y2 #= Yn,
    NextX is X1+GridSize,
    N1 is N-1,
    drawVerticalLines(NextX,Y1,Yn,GridSize,N1,Lines1,LinesR).

drawStar(Window,X0,Y0,GridSize,N,Hoshi):-N=:=19,!,
    Hoshi=[C1,C2,C3,C4,C5,C6,C7,C8,C9],
    cgCircle(Hoshi),
    HoshiWidth is GridSize//3,
    cgSame(Hoshi,width,HoshiWidth),
    cgSame(Hoshi,window,Window),
    X1 is X0+4*GridSize, X2 is X0+10*GridSize, X3 is X0+16*GridSize,
    Y1 is Y0+4*GridSize, Y2 is Y0+10*GridSize, Y3 is Y0+16*GridSize,
    C1^centerX #= X1, C1^centerY #= Y1,
    C2^centerX #= X2, C2^centerY #= Y1,
    C3^centerX #= X3, C3^centerY #= Y1,
    C4^centerX #= X1, C4^centerY #= Y2,
    C5^centerX #= X2, C5^centerY #= Y2,
    C6^centerX #= X3, C6^centerY #= Y2,
    C7^centerX #= X1, C7^centerY #= Y3,
    C8^centerX #= X2, C8^centerY #= Y3,
    C9^centerX #= X3, C9^centerY #= Y3.
drawStar(Window,X0,Y0,GridSize,N,Hoshi):-N=:=9,!,
    Hoshi=[C1,C2,C3,C4],
    cgCircle(Hoshi),
    HoshiWidth is GridSize//2,
    cgSame(Hoshi,width,HoshiWidth),
    cgSame(Hoshi,window,Window),
    X1 is X0+3*GridSize, X2 is X0+7*GridSize,
    Y1 is Y0+3*GridSize, Y2 is Y0+7*GridSize, 
    C1^centerX #= X1, C1^centerY #= Y1,
    C2^centerX #= X2, C2^centerY #= Y1,
    C3^centerX #= X1, C3^centerY #= Y2,
    C4^centerX #= X2, C4^centerY #= Y2.

drawPrisoners(jails(jail(B,BLab,BCount),jail(W,WLab,WCount)),BoardSize):-
    Y is 100+BoardSize+10,
    Width is BoardSize//8,
    BLab^x #:= 100, BLab^y #:= Y,
    BCount^x #:= 100+Width, BCount^y #:= Y,
    WLab^x #:= 100+2*Width, WLab^y #:= Y,
    WCount^x #:= 100+3*Width, WCount^y #:= Y,
    cgShow([BLab,BCount,WLab,WCount]).

%%%
oposite(white,Black):-!,Black=black.
oposite(black,White):-White=white.

askFileName(Board,Mode,FileNameString):-
    getWindow(Board,Window),
    cgFileDialog(FileDialog),FileDialog^mode #= Mode,
    FileDialog^parent #= Window,
    cgShow(FileDialog),
    cgGetFile(FileDialog,FileNameString).

%% load a game file
loadGame(Board):-
    getWindow(Board,Window),
    askFileName(Board,load,FileNameString),
    catch(readGame(Board,FileNameString),Exception,write(Exception)).

readGame(Board,FileNameString):-var(FileNameString),!. % Esc key pressed
readGame(Board,FileNameString):-
    atom_codes(FileName,FileNameString),
    readGameSteps(FileName,Steps),
    setSteps(Board,Steps),
    setFileName(Board,FileName),
    redrawBoard(Board,Steps,0).

readGameSteps(FileName,Steps):-
    see(FileName),
    read(Step),
    readGameStepsAux(Step,Steps).

readGameStepsAux(end_of_file,Steps):-!,Steps=[],seen.
readGameStepsAux(s(Row,Col),Steps):-
    integer(Row),integer(Col),
    Row>=1, Row=< 19,
    Col>=1, Col=< 19,!,
    Steps=[s(Row,Col)|Steps1],
    read(NextStep),
    readGameStepsAux(NextStep,Steps1).
readGameStepsAux(Step,Steps):-    
    throw(file_malformatted).

/* save to a game file */
saveGameAsAnimation(Board):-
    askFileName(Board,save,FileNameString),
    cgStartRecord(FileNameString),
    getSteps(Board,Steps),
    redrawBoard(Board,Steps,2000),
    cgStopRecord.

saveGame(Board):-
    getFileName(Board,FileName),
    (FileName==nil->saveGameAs(Board);saveGameToFile(Board,FileName)).

saveGameAs(Board):-
    askFileName(Board,save,FileNameString),
    (var(FileNameString)->true;
     atom_codes(FileName,FileNameString),
     catch(saveGameToFile(Board,FileName),Exception,write(Exception)),
     (nonvar(Exception)->true;setFileName(Board,FileName))).
     
saveGameToFile(Board,FileName):-
    tell(FileName),
    getSteps(Board,Steps),
    saveGameSteps(Steps).

saveGameSteps([]):-told.
saveGameSteps([s(Row,Col)|Steps]):-
    write(s(Row,Col)),write('.'),nl,
    saveGameSteps(Steps).

