go:-
    cgWindow(Win,"testMenu"),
    handleWindowClosing(Win),
    cgMenuBar(MenuBar),
    Menus=[Meast,Msouth,Mwest,Mnorth],
    cgMenu(Menus,["East","South","West","North"]),
    cgAdd(MenuBar,Menus),
    %
    cgCheckboxMenuItem(YesOrNo,"YesOrNo"),
    MeastItems=[E1,E2,Esep,E3],
    cgMenuItem(MeastItems,["East1","East2","-","East3"]),
    cgAdd(Meast,[YesOrNo|MeastItems]),
    %
    MsouthItems=[S1,S2,Ssep,S3],
    cgMenuItem(MsouthItems,["South1","South2","-","South3"]),
    cgAdd(Msouth,[YesOrNo|MsouthItems]),
    %
    MwestItems=[W1,W2,Wsep,W3],
    cgMenuItem(MwestItems,["West1","West2","-","West3"]),
    cgAdd(Mwest, [YesOrNo|MwestItems]),
    %
    MnorthItems=[N1,N2,Nsep,N3],
    cgMenuItem(MnorthItems,["North1","North2","-","North3"]),
    cgAdd(Mnorth,[YesOrNo|MnorthItems]),
    cgSetMenuBar(Win,MenuBar),
    cgShow(Win),
    cgSleep(2000),
    cgSetEnabled([Meast,Mnorth,S1,W3],0),
    cgShow(Win),
    cgSleep(2000),
    cgRemove(Mwest,W2),
    cgRemove(MenuBar,Mnorth).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

    


    
