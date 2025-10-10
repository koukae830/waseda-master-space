/* An IDE for B-Prolog, still under construction */
ide:- 
    go.

go:-
    cgWindow(Win,"B-Prolog IDE, under construction"), Win^topMargin #= 45,
    handleWindowClosing(Win),
    ide(Os,Win),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

ide(Os,Win):-
    % set up menus
    Menus=[Mrun,Mtool,Mhelp],
    cgMenu(Menus,["Run","Tool","Help"]),
    cgMenuItem([Icomp,Iconsult,Iload],
	       ["Compile","Consult","Load"]),
    cgAdd(Mrun,[Iconsult,Icomp,Iload]),
    cgSetMenuBar(Win,MenuBar),
    cgAdd(MenuBar,Menus),
    %
    cgButton([Query,Debug,Creep,Leap,Skip,Abort,Repeat,NextSol],
	     ["Query","Debug","Creep","Leap","Skip","Abort","Repeat","Next"]), 
    cgTextField(QueryTextField,"",20), QueryTextField^fontSize #= 14,
    cgChoice(History), 
    %
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,NextSol),
    cgSetEnabled([Creep,Leap,Skip,Abort,Repeat,NextSol],0),
    createConsole(Ide),
    %
    Os=[Console,ConsoleHistory,QueryTextField,History,Query,Debug,Creep,Leap,Skip,Abort,Repeat,NextSol],
    QueryTextField^height #= 26, History^height #= 20,
    cgTable([[QueryTextField,Query,Debug,Creep,Leap,Skip,Abort,Repeat,NextSol],
	     [History,Query,Debug,Creep,Leap,Skip,Abort,Repeat,NextSol]]),
    cgSame([Query,Debug,Creep,Leap,Skip,Abort,Repeat,NextSol],width),
    cgSetEnabled([Creep,Leap,Skip,Abort,Repeat,NextSol],0),
    NextSol^rightX #= Win^width,
    QueryTextField^width#=Win^width-8*Query^width,
    %
    % handle events
    handleResizeWindow(Ide),
    handleCompileFile(Icomp,Ide),
    handleConsultFile(Iconsult,Ide),
    handleLoadFile(Iload,Ide),
    handleQuery(Query,Ide),
    handleDebug(Debug,Ide),
    handleQueryFromHistory(History,Ide).

createConsole(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    cgTextArea(Console),Console^editable #= 0,
    Console^width #= Win^width,
    Console^height #= 3*(Win^height-Win^topMargin-QueryTextField^height-History^height)//4,
    cgBelow(Console,History),
    % 
    cgTextArea(ConsoleHistory), ConsoleHistory^editable #= 0,
    ConsoleHistory^width #= Win^width,
    ConsoleHistory^height #= Console^height//3,
    cgBelow(ConsoleHistory,Console),
    %
    cgSame([Console,ConsoleHistory],fontName,"TimesRoman"),
    cgSame([Console,ConsoleHistory],fontSize,14).

getFileName(FileName,Win):-
    cgFileDialog(FileDialog),FileDialog^mode #= load,
    FileDialog^parent #= Win,
    cgShow(FileDialog),
    cgGetDirectory(FileDialog,DirectoryCodes),
    cgGetFile(FileDialog,FileCodes),
    append(DirectoryCodes, FileCodes,FullPathCodes),
    (var(FileCodes)->true;
     append(MainNameCodes,[0'.|_],FullPathCodes),
     atom_codes(FileName,MainNameCodes)).

handleResizeWindow(Ide),
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,NextSol),
    {componentResized(Win,E)} 
    =>
    History^width #:= Win^width-8*Query^width,
    QueryTextField^width #:= History^width,
    Console^width #:= Win^width,
    Console^height #:= 3*(Win^height-Win^topMargin-History^height-QueryTextField^height)//4,
    ConsoleHistory^width #:= Win^width,
    ConsoleHistory^height #:= Win^height-Console^y-Console^height,
    ConsoleHistory^y #:= Console^bottomY,
    NextSol^x #:= Win^width-NextSol^width,
    Repeat^x #:= NextSol^x - Repeat^width,
    Abort^x #:= Repeat^x - Abort^width,
    Skip^x #:= Abort^x - Skip^width,
    Leap^x #:= Skip^x - Leap^width,
    Creep^x #:= Leap^x - Creep^width,
    Debug^x #:= Creep^x - Debug^width,
    Query^x #:= Debug^x - Query^width,
    cgShow([History,QueryTextField,Console,ConsoleHistory,Query,Debug,Creep,Leap,Skip,Abort,Repeat,NextSol]).

handleCompileFile(Icomp,Ide),
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    {actionPerformed(Icomp)} 
    =>
    getFileName(FileName,Win),
    (var(FileName)->true;
     catch(compile(FileName),Exception,handleException(Exception,Ide))).
    
handleLoadFile(Iload,Ide),
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    {actionPerformed(Iload)} 
    =>
    getFileName(FileName,Win),
    (var(FileName)->true;
     atom_codes(FileName,MainString),
     append(MainString,".out",ByteFileNameString),
     atom_codes(ByteFileName,ByteFileNameString),
     (exists(ByteFileName)->
      catch(load(FileName),Exception1,handleException(Exception1,Ide));
      catch(compile(FileName),Exception2,handleException(Exception2,Ide)),
      catch(load(FileName),Exception3,handleException(Exception3,Ide)))).

handleConsultFile(Iconsult,Ide),
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    {actionPerformed(Iconsult)} 
    =>
    getFileName(FileName,Win),
    (var(FileName)->true;
     atom_codes(FileName,FileNameString),
     catch(consult(FileName),Exception2,handleException(Exception2,Ide))).

handleQuery(Query,Ide), % Query maybe a button or textfield
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    {actionPerformed(Query)} 
    =>
    copyConsoleToHistory(Console,ConsoleHistory),
    cgGetText(QueryTextField,Text), 
    evaluateQuery(Text,Ide,0),
    cgSetText(QueryTextField,""),
    cgShow(QueryTextField).

handleDebug(Debug,Ide), % Query maybe a button or textfield
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    {actionPerformed(Debug)} 
    =>
    copyConsoleToHistory(Console,ConsoleHistory),
    cgGetText(QueryTextField,Text), 
    evaluateQuery(Text,Ide,1),
    cgSetText(QueryTextField,""),
    cgShow(QueryTextField).

handleQueryFromHistory(History,Ide),
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
     {itemStateChanged(History,E)} 
     =>
     E^index #= I,
     cgSelectedItem(History,Item),
     cgSetText(QueryTextField,Item),
     cgShow(QueryTextField).

copyConsoleToHistory(Console,ConsoleHistory):-
    cgGetText(ConsoleHistory, CHText),
    cgGetText(Console,CText),
    append(CHText,CText,NCHText),
    cgSetText(ConsoleHistory,NCHText),
    cgSetText(Console,""),
    cgShow(ConsoleHistory),
    cgShow(Console).

evaluateQuery("",Ide,D):-!.
evaluateQuery(Text,Ide,D):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    (parse_string(Text,Term,Vars)->
      append(Text,"\n",Text1),
      cgGetText(Console,CurText),
      append(CurText,[0'?,0'-|Text1],NText),
      cgSetText(Console,NText),
      addChoiceItemIfNotExist(History,Text),
      cgShow(History),
      (D==0->ide_eval(Term,Vars,Ide);  % defined separately
       ide_debug(Term,Vars,Ide));
      true).

addChoiceItemIfNotExist(Choice,Item):-
    Choice^count#=N,
    itemExist(Choice,1,N,Item),!.
addChoiceItemIfNotExist(Choice,Item):-
    cgAdd(Choice,Item),
    cgShow(Choice).
    
itemExist(Choice,N0,N,Item):-N0>N,!,fail.
itemExist(Choice,N0,N,Item):-
    Choice^item(N0) #= Item1,
    Item=Item1,!.
itemExist(Choice,N0,N,Item):-
    N1 is N0+1,
    itemExist(Choice,N1,N,Item).
    
/* operations on the Ide object */
ide_append_console(Ide,Line):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    cgGetText(Console,Text),
    append(Text,Line,NText),
    cgSetText(Console,NText),
    garbage_collect.

ide_show_console(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    cgShow(Console).

ide_get_next(Ide,Next):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next).

ide_get_abort(Ide,Abort):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next).

disableQueryDebug(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled([Query,Debug],0),
    cgShow([Query,Debug]).

enableQueryDebug(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled([Query,Debug],1),
    cgShow([Query,Debug]).

enableAbortNext(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled([Abort,Next],1),
    cgShow([Abort,Next]).

enableSkip(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled(Skip,1),
    cgShow(Skip).

disableSkip(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled(Skip,0),
    cgShow(Skip).

disableNext(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled(Next,0),
    cgShow(Next).

enableLeap(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled(Leap,1),
    cgShow(Leap).

disableLeap(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled(Leap,0),
    cgShow(Leap).

enableControlButtons(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled([Creep,Leap,Skip,Abort,Repeat],1),
    cgShow([Creep,Leap,Skip,Abort,Repeat,Next]).

disableControlButtons(Ide):-
    Ide=ide(Win,History,QueryTextField,Console,ConsoleHistory,ControlPan),
    ControlPan=cp(Query,Debug,Creep,Leap,Skip,Abort,Repeat,Next),
    cgSetEnabled([Creep,Leap,Skip,Abort,Repeat,Next],0),
    cgShow([Creep,Leap,Skip,Abort,Repeat,Next]).

handleException(Exception,ChoicePoint,Ide):-
    ide_write(Exception,Ide),ide_nl(Ide),
    enableQueryDebug(Ide),
    cutto(ChoicePoint),
    fail.

handleException(Exception,Ide):-
    ide_write(Exception,Ide),ide_nl(Ide),
    enableQueryDebug(Ide).

