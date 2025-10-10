%:-set_prolog_flag(gc_threshold,9000000).

:-write('type main to start'),nl.

main:-
    catch(top,Exception,(write(Exception),nl,halt)),
    $event_watching_loop.
main:-main.

top:-
    cgWindow(ControlWin,"CGLIB Examples"), 
    cgSetTitle(ControlWin,"CGLIB Exs"), 
    ControlWin^width#=800,
    ControlWin^height#=700,
    ControlWin^topMargin#=25,ControlWin^leftMargin#=15,
    cgTextArea(TextArea),TextArea^editable #= 0,
    createIndex(Indexes,IndexPanWidth,TextArea),
    cgSame([TextArea|Indexes],window,ControlWin),
    cgLeft(Indexes,TextArea),
    TextArea^width#=ControlWin^width-IndexPanWidth-15,
    TextArea^height#=ControlWin^height,
    TextArea^fontStyle#=bold,
    handleControlWindowClosing(ControlWin),
    handleControlWindowEnlarge(ControlWin,IndexPanWidth,TextArea),
    handleControlWindowMove(ControlWin),
    cgPack([TextArea|Indexes]),
    cgShow(TextArea),
    cgStartRecord('index'),
    cgShow(Indexes),
    cgStopRecord.

createIndex(Indexes,IndexPanWidth,TextArea):-
    Outlines=[OutlineIllustrations,OutlineGraphics,OutlineCsps,OutlineGuis,OutlineGames,OutlineAnimations],
    cgLabel(Outlines,["Illustrative Examples",
		      "Drawing Graphics", 
		      "Constraint Satisfaction Problems",
		      "Graphical User Interfaces",
		      "Games",
		      "Animations"]),
    cgSame(Outlines,color,red),
    cgSame(Outlines,fontStyle,bold),
    cgSame(Outlines,fontSize,16),

    illustrative(LabIllustrations),
    length(LabIllustrations,N1),
    length(Illustrations,N1),
    
    graphics(LabGraphics),
    length(LabGraphics,N2),
    length(Graphics,N2),

    guis(LabGuis),
    length(LabGuis,N4),
    length(Guis,N4),
    
    csps(LabCsps),
    length(LabCsps,N5),
    length(Csps,N5),
    
    animations(LabAnimations),
    length(LabAnimations,N7),
    length(Animations,N7),

    games(LabGames),
    length(LabGames,N8),
    length(Games,N8),

    appendListList([LabIllustrations,LabGraphics,LabGuis,LabCsps,LabGames,LabAnimations],Labs),
    appendListList([Illustrations,Graphics,Guis,Csps,Games,Animations],Checkboxes),
    cgCheckboxGroup(Checkboxes,Labs),
    cgSame(Checkboxes,fontSize,13),
    append(Outlines,Checkboxes,Indexes),

    toTabularForm([[OutlineIllustrations|Illustrations],
		   [OutlineGraphics|Graphics],
		   [OutlineCsps|Csps],
		   [OutlineGuis|Guis],
		   [OutlineGames|Games],
		   [OutlineAnimations|Animations]],Table,[]),
    

    cgTable(Table,0,5),
%    OutlineIllustrations^width #= IndexPanWidth,
    handleCheckboxes(Checkboxes,Checkboxes,TextArea).

appendListList(Lists,List):-
    appendListList(Lists,List,[]).

appendListList([],List,ListR):-List=ListR.
appendListList([L|Ls],List,ListR):-
    append(L,Tail,List),!,
    appendListList(Ls,Tail,ListR).

toTabularForm([],Rows,RowsR):-Rows=RowsR.
toTabularForm([Block|Blocks],Rows,RowsR):-
    toTabularFormBlock(Block,Rows,Rows1),
    toTabularForm(Blocks,Rows1,RowsR).

toTabularFormBlock([Outline|Members],Rows,RowsR):-
    Rows=[[Outline,Outline,Outline,Outline]|Rows1],
    toTabularFormMembers(Members,Rows1,RowsR).

toTabularFormMembers([],Rows,RowsR):-Rows=RowsR.
toTabularFormMembers([M],Rows,RowsR):-!,Rows=[[M,_,_,_]|RowsR].
toTabularFormMembers([M1,M2],Rows,RowsR):-!,
    Rows=[[M1,M2,_,_]|RowsR].
toTabularFormMembers([M1,M2,M3],Rows,RowsR):-
    Rows=[[M1,M2,M3,_]|RowsR].
toTabularFormMembers([M1,M2,M3,M4|Ms],Rows,RowsR):-
    Rows=[[M1,M2,M3,M4]|Rows1],
    toTabularFormMembers(Ms,Rows1,RowsR).

handleCheckboxes([],AllCheckboxes,TextArea).
handleCheckboxes([Checkbox|Checkboxes],AllCheckboxes,TextArea):-
    handleCheckbox(Checkbox,AllCheckboxes,TextArea),
    handleCheckboxes(Checkboxes,AllCheckboxes,TextArea).


handleCheckbox(Checkbox,AllCheckboxes,TextArea),{itemStateChanged(Checkbox,E)} =>
    cgSetEnabled(AllCheckboxes,0),
    cgGetText(Checkbox,Text),
    cgShow(AllCheckboxes),
    % string to name
    atom_codes(Name,Text),
    append(Text,".pl",String),atom_codes(PlName,String),
    readFile(PlName,Codes),
    cgSetText(TextArea,Codes),
    cgPack(TextArea),
    cgShow(TextArea),
    catch((compile(Name),load(Name),go),Exception,write(Exception)),
%    catch((load(Name),go),Exception,write(Exception)),
    statistics,
    cgSetEnabled(AllCheckboxes,1),
    cgShow(AllCheckboxes).

handleControlWindowEnlarge(ControlWin,IndexPanWidth,TextArea),{componentResized(ControlWin,E)} =>
    ControlWin^width #= Width,
    ControlWin^height #= Height,
    NewTAWidth is Width-IndexPanWidth-15,
    TextArea^width #:= NewTAWidth,
    TextArea^height #:= Height,
    cgShow(TextArea).

handleControlWindowMove(ControlWin),{componentMoved(ControlWin,E)} =>
    X #= E^x, Y #= E^y,
    ControlWin^x #:= X,
    ControlWin^y #:= Y.

handleControlWindowClosing(Win),{windowClosing(Win)} =>
    halt.


illustrative(["allBuiltinComponents",
	      "hello",
	      "recCircleRec",
	      "scribble",
	      "testArrow",
	      "testComponentEvent",
	      "testCursor",
	      "testKeyEvent",
	      "testList",
	      "testMenu",
	      "testTriangle",
	      "testTree",
	      "testWindowEvent"]).


graphics(["binaryTree",
          "drawterm",
	  "domino",
	  "circles",
	  "circleChart",
	  "face",
	  "flags",
	  "javaclasses",
	  "sierpinski",
	  "squareAndDiamonds",
 	  "squares",
	  "triangles",
	  "pythagoras"]).

guis(["boxesAndArrows",
      "calculator",
      "calendar",
      "geometryTheorem",
      "ide",
      "movingBox",
      "palette",
      "temperature"]).

csps(["boxLayout",
      "knighttour",
     "magic4",
     "marriage",
     "queens",
      "newspaper",
     "route",
     "sendmory",
      "sudoku",
     "zebra",
     "dominopuzzle",
     "schedule"]).

games(["chess",
       "fiveChess",
       "eightPuzzle",
       "knight",
       "igo",
       "othello"]).

animations(["movingBall",
	    "clocks",
	    "flags",
	    "hanoi",
	    "sort"]).




		     


    

