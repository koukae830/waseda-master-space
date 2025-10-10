go:-
    cgWindow(Win,"testKeyEvent"),
    Win^topMargin #= 100, Win^leftMargin #= 100,
    cgTextArea(T),
    cgSetRows(T,40),cgSetColumns(T,40),
    T^window #= Win,
    handleKeyTyped(Win,T),
    handleKeyTyped(T,T),
    handleKeyPressed(Win,T),
    handleKeyPressed(T,T),
    handleKeyReleased(Win,T),
    handleKeyReleased(T,T),
    cgShow(T).

handleKeyTyped(Win,T),{keyTyped(Win,E)} =>
    outputEvent(E,T,keyTyped).
    
handleKeyPressed(Win,T),{keyPressed(Win,E)} =>
    outputEvent(E,T,keyPressed).

handleKeyReleased(Win,T),{keyReleased(Win,E)} =>
    outputEvent(E,T,keyReleased).

outputEvent(E,T,EventType):-
    E^char #= Char, % KeyEvent does not convey the char or code of the typed key
    E^code #= Code,
    (cgShiftIsDown(E)->Shift=1;Shift=0),
    (cgControlIsDown(E)->Control=1;Control=0),
    (cgMetaIsDown(E)->Meta=1;Meta=0),
    (cgAltIsDown(E)->Alt=1;Alt=0),
    Mes=..[EventType,Char,Code,Shift,Control,Meta,Alt],
    write(Mes),nl,
    term2string(Mes,Text),
    cgAppend(T,Text),
    cgAppend(T,"\n").

