/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    draw a "Hello World!" button
*********************************************************************/
go:-
    cgButton(B,"Hello World!"),
    B^fontSize #=20,
    cgWindow(Win,"hello"),Win^topMargin #= 50, Win^leftMargin #= 30,
    B^window #= Win, 
    handleButtonClick(B),
    handleWindowClosing(Win),
    cgShow([B]).
go.

handleButtonClick(B),{actionPerformed(B)} => write(hello).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).



