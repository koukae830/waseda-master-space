/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw a diagram that shows the hierarchy of Java AWT's classes
*********************************************************************/
go:-
    cgWindow(Win,"java classes"),Win^topMargin #= 30, Win^leftMargin#=10, 
    handleWindowClosing(Win),
    generateNodes(Tree,Os),
    connectTree(Tree,Ls,[]),
    cgTree(Tree,left_right,10,2,centered),
    cgSame(Os,fontSize,10),
    cgSame(Os,window,Win), 
    cgSame(Ls,window,Win), 
    cgStartRecord(javaclasses1),
    cgShow(Os),
    cgShow(Ls),
    cgStopRecord.

generateNodes(Tree,Os):-
    Os=[Object,Component,Button,Canvas,Checkbox,CheckboxMenuItem,Choice,
        Container,Dialog,FileDialog,Frame,Label,List,MenuComponent,Menu,
        MenuBar,MenuItem,Panel,Applet,PopupMenu,Scrollbar,ScrollPane,
        TextArea,TextComponent,TextField,Window],
    Labs=["Object","Component","Button","Canvas","Checkbox","CheckboxMenuItem","Choice",
          "Container","Dialog","FileDialog","Frame","Label","List","MenuComponent","Menu",
          "MenuBar","MenuItem","Panel","Applet","PopupMenu","Scrollbar","ScrollPane",
          "TextArea","TextComponent","TextField","Window"],
    cgTextBox(Os,Labs),
    Tree=node(Object,
              [node(Component,
                    [node(Button,[]),
                     node(Canvas,[]),
                     node(Checkbox,[]),
                     node(Choice,[]),
                     node(Container,
                          [node(Window,
                                [node(Frame,[]),
                                 node(Dialog,
                                      [node(FileDialog,[])])]),
                           node(Panel,
                                [node(Applet,[])]),
                           node(ScrollPane,[])]),
                     node(Label,[]),
                     node(List,[]),
                     node(Scrollbar,[]),
                     node(TextComponent,
                          [node(TextArea,[]),
                           node(TextField,[])])]),
               node(MenuComponent,
                    [node(MenuBar,[]),
                     node(MenuItem,
                          [node(Menu,[node(PopupMenu,[])]),
                     node(CheckboxMenuItem,[])])])]).

connectTrees([],Ls,LsR):-Ls=LsR.
connectTrees([C|Cs],Ls,LsR):-
    connectTree(C,Ls,Ls1),
    connectTrees(Cs,Ls1,LsR).

connectTree(node(Box,[]),Ls,LsR):-!,Ls=LsR.
connectTree(node(Box,Children),[Vl,Hl|Ls],LsR):-
    getFirst(Children,node(FirstC,_)),
    getLast(Children,node(LastC,_)),
    cgLine(Vl),
    Vl^y1 #= FirstC^centerY, Vl^y2 #= LastC^centerY,
    Vl^x1 #= Vl^x2, Vl^x1 #= Box^rightX+4,
    %
    cgLine(Hl),
    Hl^x1 #= Box^rightX, Hl^x2 #= Vl^x1,
    Hl^y1 #= Box^centerY, Hl^y2 #= Hl^y1,
    %
    connectChildren(Vl,Children,Ls,Ls1),    
    connectTrees(Children,Ls1,LsR).

getFirst([X|Xs],X).

getLast(L,X):-
    reverse(L,RL),
    getFirst(RL,X).

connectChildren(Line,[],Ls,LsR):-Ls=LsR.
connectChildren(Line,[node(C,_)|Cs],Ls,LsR):-
    cgLine(L),
    Ls=[L|Ls1],
    L^x1 #= Line^x1, L^x2 #= C^x-2,
    L^y1 #= C^centerY, L^y2 #= L^y1,
    connectChildren(Line,Cs,Ls1,LsR).
    
handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

