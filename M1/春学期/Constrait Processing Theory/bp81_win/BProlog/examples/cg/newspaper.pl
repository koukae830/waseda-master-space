/* (C) Afany Software, all rights reserved.
Problem description: Four roommates named Algy, Bertie, Charlie, and Digby are subscribing to four newspapers:
Financial times, Guardian, Daily express, and Sun. Each person has different interests and spend different 
amounts of time reading the newspapers. The following gives the amounts of time each person spend on each newspaper:

    Person/Newspaper/Minutes
    ================================================================
    Person || Financial times  | Guardian | Daily express | Sun
    ----------------------------------------------------------------
    Algy   ||     60          |   30     |      2        |  5
    ----------------------------------------------------------------
    Bertie ||     75          |    3     |     15        | 10
    ----------------------------------------------------------------
    Charlie||      5          |   15     |     10        | 30
    ----------------------------------------------------------------
    Digby  ||     90          |    1     |      1        |  1
    ================================================================
Algy gets up at 7:00, Bertie gets up at 7:15, Charlie gets up at 7:15, and Digby gets up at 8:00. Nobody can
read more than one newspaper at a time and at any time a newspaper can be read by only one person. 
Schedule the newspapers such that the four persons finish the newspapers at an earliest possible time.
*/
go:-
    Algy=person(algy,0,
		60,Algy_F,30,Algy_G,2,Algy_E,5,Algy_S),
    Bertie=person(bertie,15,
		  75,Bertie_F,3,Bertie_G,15,Bertie_E,10,Bertie_S),
    Charlie=person(charlie,15,
		   5,Charlie_F,15,Charlie_G,10,Charlie_E,30,Charlie_S),
    Digby=person(digby,60,
		 90,Digby_F,1,Digby_G,1,Digby_E,1,Digby_S),
    Vars=[Algy_F,Algy_G,Algy_E,Algy_S,Bertie_F,Bertie_G,Bertie_E,Bertie_S,
	  Charlie_F,Charlie_G,Charlie_E,Charlie_S,
	  Digby_F,Digby_G,Digby_E,Digby_S],
    Vars :: 0..300,
    %
    cumulative([Algy_F,Algy_G,Algy_E,Algy_S],[60,30,2,5],[1,1,1,1],1),
    cumulative([Bertie_F,Bertie_G,Bertie_E,Bertie_S],[75,3,15,10],[1,1,1,1],1),
    cumulative([Charlie_F,Charlie_G,Charlie_E,Charlie_S],[5,15,10,30],[1,1,1,1],1),
    cumulative([Digby_F,Digby_G,Digby_E,Digby_S],[90,1,1,1],[1,1,1,1],1),
    %
    cumulative([Algy_F,Bertie_F,Charlie_F,Digby_F],[60,75,5,90],[1,1,1,1],1),
    cumulative([Algy_G,Bertie_G,Charlie_G,Digby_G],[30,3,15,1],[1,1,1,1],1),
    cumulative([Algy_E,Bertie_E,Charlie_E,Digby_E],[2,15,10,1],[1,1,1,1],1),
    cumulative([Algy_F,Bertie_F,Charlie_F,Digby_F],[5,10,30,1],[1,1,1,1],1),
    %
    max([60+Algy_F,30+Algy_G,2+Algy_E,5+Algy_S,
	 75+Bertie_F,3+Bertie_G,15+Bertie_E,10+Bertie_S,
	 5+Charlie_F,15+Charlie_G,10+Charlie_E,30+Charlie_S,
	 90+Digby_F,1+Digby_G,1+Digby_E,1+Digby_S]) #= EndTime,
    minof(labeling(Vars),EndTime),
    writeln(EndTime),
    visualizeSol([Algy,Bertie,Charlie,Digby]).

visualizeSol([Algy,Bertie,Charlie,Digby]):-
    cgWindow(Win,"Newspaper Scheduler"), 
    Win^topMargin #= 40, Win^leftMargin #= 10,
    Win^width #= 800,
    handleClose(Win),
    Labs=[Algy_l,Bertie_l,Charlie_l,Digby_l],
    cgLabel(Labs,["Algy","Bertie","Charlie","Digby"]),
    cgTable([[Algy_l],[Bertie_l],[Charlie_l],[Digby_l]],0,5),
    cgSame(Labs,size),
    cgSame(Labs,fontStyle,bold),
    cgSame(Labs,fontSize,16),
    cgSame(Labs,window,Win),
    cgShow(Labs),
    visulizePerson(Win,Algy_l,Algy),
    visulizePerson(Win,Bertie_l,Bertie),
    visulizePerson(Win,Charlie_l,Charlie),
    visulizePerson(Win,Digby_l,Digby).

visulizePerson(Win,Lab,person(Name,T0,DF,TF,DG,TG,DE,TE,DS,TS)):-
    cgRectangle([RF,RG,RE,RS]),
    constrainNewspaper(RF,Lab,TF,DF,black),
    constrainNewspaper(RG,Lab,TG,DG,blue),
    constrainNewspaper(RE,Lab,TE,DE,green),    
    constrainNewspaper(RS,Lab,TS,DS,red),
    cgSame([RF,RG,RE,RS],window,Win),
    cgShow([RF,RG,RE,RS]).

constrainNewspaper(R,Lab,T,D,Color):-
    R^x #= Lab^rightX+T*3,
    R^y #= Lab^y,
    R^height #= Lab^height,
    R^width #= D*3,
    R^color #= Color.

handleClose(Win),{windowClosing(Win)} => halt.


