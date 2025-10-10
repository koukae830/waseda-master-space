/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    a working calculator 
*********************************************************************/
go:-
    calculator(Display,Os),
    cgWindow(Win,"calculator"),Win^topMargin #= 30, Win^leftMargin #= 10,
    handleWindowClosing(Win),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

calculator(Display,Os):-
    % components
    cgTextField(Display), Display^fontSize #= 16,
    cgSetEditable(Display,0),
    %
    Buttons=[B0,B1,B2,B3,B4,B5,B6,B7,B8,B9,Bc,Bdiv,Bmul,Bsub,Badd,Beq,Bdot],
    Ts=["0","1","2","3","4","5","6","7","8","9","C","/","*","-","+","=","."],
    cgButton(Buttons,Ts),
    Display^width #= B0^width*2,
    B0^width #>50,
    %
    cgFont(F),F^size#=20,F^style#=bold,
    cgSame(Buttons,font,F),
    cgAbove(Display,Bc),
    cgGrid([[Bc,Bdiv,Bmul,Bsub],
	    [B7,B8,  B9,  Badd],
	    [B4,B5,  B6,  Badd],
	    [B1,B2,  B3,  Beq],
	    [B0,B0,  Bdot,Beq]],1,1),
    %
    Cal=cal(Display,0,"+",result_is_on),
    handleButtons(Buttons,Cal),
    Os=[Display|Buttons].

%%
handleButtons([],Cal).
handleButtons([B|Bs],Cal):-
    handleButton(B,Cal),
    handleButtons(Bs,Cal).

handleButton(B,Cal),{actionPerformed(B)} =>
    cgGetText(B,Text),
    catch(handleButtonAction(Text,Cal),_,true).

handleButtonAction("C",Cal):-!,  
    Cal=cal(Display,_Acc,_Op,_OnDisplay),
    setarg(2,Cal,0),   % acc
    setarg(3,Cal,"+"), % op
    setarg(4,Cal,result_is_on), % result on display
    cgSetText(Display,""),
    cgShow(Display).
handleButtonAction(Op,Cal):-operator(Op),!,
    (Cal=cal(_Display,_Acc,_Op,operand_is_on)->applyOperation(Cal);true),
    setarg(3,Cal,Op).
handleButtonAction("=",Cal):-!,
    applyOperation(Cal).
handleButtonAction(X,Cal):-
    appendInput(X,Cal).

%% operations on Cal
appendInput(X,Cal):-
    Cal=cal(Display,_Acc,_Op,result_is_on),!, % result is on display
    cgSetText(Display,""),
    setarg(4,Cal,operand_is_on),
    appendInput(X,Cal).
appendInput(".",Cal):-
    Cal=cal(Display,_Acc,_Op,OnDisplay),
    cgGetText(Display,Operand),
    member(0'.,Operand),!.  %0'.=X -> [X]="0"
appendInput([D],Cal):-
    Cal=cal(Display,_Acc,_Op,OnDisplay),
    cgGetText(Display,CurText),
    append(CurText,[D],NewText),
    cgSetText(Display,NewText),
    cgShow(Display).

applyOperation(Cal):-
    Cal=cal(Display,Acc,Op,OnDisplay),
    cgGetText(Display,String), number_codes(Operand,String),
    applyOperation(Op,Acc,Operand,NewAcc),
    number_codes(NewAcc,NewString), cgSetText(Display,NewString),
    setarg(2,Cal,NewAcc),	   
    setarg(4,Cal,result_is_on),
    cgShow(Display).
    
operator("+").
operator("-").
operator("/").
operator("*").

applyOperation("+",Op1,Op2,Res):-Res is Op1+Op2.
applyOperation("-",Op1,Op2,Res):-Res is Op1-Op2.
applyOperation("*",Op1,Op2,Res):-Res is Op1*Op2.
applyOperation("/",Op1,Op2,Res):-Res is Op1/Op2.

