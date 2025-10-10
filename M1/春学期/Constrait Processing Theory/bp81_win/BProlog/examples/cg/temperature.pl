/* convert Fahrenheit to and from Celsius (C = (F-32)/1.8). */
go:-
    cgWindow(Win,"Temperature"),Win^topMargin #= 30,
    handleWindowClosing(Win),
    temperature(Os),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

temperature(Os):-
    % components and constraints
    Ls=[Lf,Lc], cgLabel(Ls,["Fahrenheit","Celsius"]),
    cgSetAlignment(Ls,center),
    cgTextField([Tf,Tc],["0","-17"]), 
    cgScrollbar(Sf,vertical,0,1,-150,150),
    cgScrollbar(Sc,vertical,-17,1,-101,65),
    Sf^color #= red, Sc^color #= blue,
    Sf^height #= 100,
    cgTable([[Lf,Lc],[Sf,Sc],[Tf,Tc]],50,20),
    % event handling
    Os=[Lf,Lc,Sf,Sc,Tf,Tc],
    handleInput(fahrenheit,Tf,Os),
    handleInput(celsius,Tc,Os),
    handleAdjustment(fahrenheit,Sf,Os),
    handleAdjustment(celsius,Sc,Os).

handleInput(Scale,T,Os),{actionPerformed(T)} =>
    cgGetText(T,ValueString),
    number_codes(Value,ValueString),
    convert(Scale,Value,Os).

handleAdjustment(Scale,Scrollbar,Os),{adjustmentValueChanged(Scrollbar)} =>
    cgGetValue(Scrollbar,Value),
    convert(Scale,Value,Os).

convert(fahrenheit,Value,Os):-
    Os=[Lf,Lc,Sf,Sc,Tf,Tc],
    cgSetValue(Sf,Value),
    number_codes(Value,ValueString),
    cgSetText(Tf,ValueString),
    Cel is (Value-32)/1.8,
    IntCel is round(Cel),
    cgSetValue(Sc,IntCel),
    number_codes(Cel,CelString),
    cgSetText(Tc,CelString),
    cgShow(Os).
convert(celsius,Value,Os):-
    Os=[Lf,Lc,Sf,Sc,Tf,Tc],
    cgSetValue(Sc,Value),
    number_codes(Value,ValueString),
    cgSetText(Tc,ValueString),
    Fah is Value*1.8+32,
    IntFah is round(Fah),
    cgSetValue(Sf,IntFah),
    number_codes(Fah,FahString),
    cgSetText(Tf,FahString),
    cgShow(Os).

