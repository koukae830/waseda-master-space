/********************************************************************
    Constraint-based Graphical Programming in B-Prolog
    %
    Illustrate the use of all the CG components
*********************************************************************/
go:-
    allComponents.
go.

allComponents:-
    cgMenuBar(MenuBar),
    Menus=[Meast,Msouth,Mwest,Mnorth],
    cgMenu(Menus,["East","South","West","North"]),
    cgAdd(MenuBar,Menus),
    %
    cgCheckboxMenuItem(YesOrNo1,"YesOrNo"),
    MeastItems=[E1,E2,Esep,E3],
    cgMenu(MeastItems,["East1","East2","-","East3"]),
    cgSetEnabled(E3,0),
    cgAdd(Meast,[YesOrNo1|MeastItems]),
    cgMenuItem([E11,E12,E21,E22,E31,E32],["East11","East12","East21","East22","East31","East32"]),
    cgAdd(E1,[E11,E12]), cgAdd(E2,[E21,E22]), cgAdd(E3,[E31,E32]),
    %
    cgCheckboxMenuItem(YesOrNo2,"YesOrNo"),
    MsouthItems=[S1,S2,Ssep,S3],
    cgMenuItem(MsouthItems,["South1","South2","-","South3"]),
    cgAdd(Msouth,[YesOrNo2|MsouthItems]),
    %
    cgCheckboxMenuItem(YesOrNo3,"YesOrNo"),
    MwestItems=[W1,W2,Wsep,W3],
    cgMenuItem(MwestItems,["West1","West2","-","West3"]),
    cgAdd(Mwest,[YesOrNo3|MwestItems]),
    %
    cgCheckboxMenuItem(YesOrNo4,"YesOrNo"),
    MnorthItems=[N1,N2,Nsep,N3],
    cgMenuItem(MnorthItems,["North1","North2","-","North3"]),
    cgAdd(Mnorth,[YesOrNo4|MnorthItems]),
    cgSetEnabled(Mnorth, 0),

    cgWindow(Win,"allComponents"),Win^topMargin #= 50,
    Win^height #= 600,
    handleWindowClosing(Win),
    cgSetMenuBar(Win,MenuBar),

    cgArc(Arc), Arc^startAngle #= 20, Arc^arcAngle #= 150,
    cgButton(Button,"Button"),
    cgCircle(Circle), 

    cgLabel(Label,"Label"),
    cgSetAlignment(Label,center),
    cgLine(Line), Line^thickness #= 5, Line^arrow1 #= 1,
    Line^x2-Line^x1 #= Line^width, Line^y2-Line^y1 #= Line^height,
    cgOval(Oval), 2*Oval^width #= 3*Oval^height,
    %
    cgPolygon(Polygon), Polygon^n #= 5,
    Polygon^x(2) #= Polygon^x(1),
    Polygon^y(2) #= Polygon^y(1)+Polygon^height/2,
    Polygon^x(3) #= Polygon^x(1)+Polygon^width/2,
    Polygon^y(3) #= Polygon^y(1)+Polygon^height,
    Polygon^x(4) #= Polygon^x(1)+Polygon^width,
    Polygon^y(4) #= Polygon^y(2),
    Polygon^x(5) #= Polygon^x(1)+Polygon^width/2,
    Polygon^y(5) #= Polygon^y(1),
    %
    cgRectangle(Rectangle), 
    Rectangle^width//3 #= Rectangle^height//2,
    cgRoundRectangle(Rrectangle), 
    Rrectangle^arcWidth #>= Rrectangle^width/4, 
    Rrectangle^arcHeight #>= Rrectangle^height/4,
    %
    cgSquare(Square),
    cgStar(Star),Star^n #= 5,
    %
    cgTextArea(TextArea), cgSetText(TextArea,"Text area"),
    cgSetEditable(TextArea,0),
    cgSetRows(TextArea,4), % TextArea^columns #= 10,
    cgTextField(TextField), 
    cgSetText(TextField,"Text Field"), 
    cgSetEditable(TextField,1),
    %
    cgTextBox(TextBox,"TextBox"),TextBox^fontSize #= 9,
    %
    cgTriangle(Triangle), Triangle^x2 #= Triangle^x1+Triangle^width, Triangle^y2 #= Triangle^y1,
    Triangle^x3 #= Triangle^x1, Triangle^y3 #= Triangle^y1-Triangle^height,
    %
    cgImage(Image), Image^name #= "animal1.gif",
    %
    cgList(List),cgAdd(List,["one","two","three"]),
    %
    cgChoice(Choice),cgAdd(Choice,["yi","er","san"]),
    %
    cgCheckbox(Checkbox,"check"),
    %
    Labels=[Larc,Lbutton,Lcircle,Llabel,Lline,Loval,Lpolygon,Lrectangle,Lrrectangle, 
	    Lsquare, Lstar, Ltextarea,Ltextfield, Ltriangle, Limage,Llist,Lchoice,Lcheckbox,Ltextbox,Lstring,Lscrollbar],
    Texts=["Arc","Button","Circle","Label","Line","Oval","Polygon","Rectangle","RoundRectangle", 
	   "Square", "Star", "TextArea","TextField", "Triangle", "Image","List","Choice","Checkbox","TextBox","String","Scrollbar"],

    cgString(String,"String"),
    cgScrollbar(Scrollbar),
    cgLabel(Labels,Texts),
    cgSame(Labels,fontStyle,bold),
    cgSame(Labels,fontSize,11),

    cgSame(Labels,color,blue),
    %
    Comps=[Larc,Arc,Button,Lbutton,
	   Lcircle,Circle,Label,Llabel,
	   Lline,Line,Oval,Loval,
	   Lrrectangle,Rrectangle,Rectangle,Lrectangle,
	   Lpolygon,Polygon,Square,Lsquare,
	   Lstar,Star,TextArea,Ltextarea,
	   Ltextfield,TextField,Triangle,Ltriangle,
	   TextBox,Ltextbox,
	   Limage,Image,List,Llist,
	   Lchoice,Choice,Lcheckbox,Checkbox,Lstring,String,Lscrollbar,Scrollbar],
    cgTable([[Larc,Arc,Button,Lbutton],
	     [Lcheckbox, Checkbox, Choice, Lchoice],
	     [Lcircle,Circle,Image,Limage],
	     [Llabel,Label,Line,Lline],
	     [Llist,List,Oval,Loval],
	     [Lrrectangle,Rrectangle,Rectangle,Lrectangle],
	     [Lpolygon,Polygon,Square,Lsquare],
	     [Lscrollbar,Scrollbar,Star,Lstar],
	     [Lstring,String,TextArea,Ltextarea],
	     [Ltextfield,TextField,TextBox,Ltextbox],
	     [Ltriangle,Triangle,_,_]],20,20),

    cgSetAlignment([Larc,Lcircle,Lpolygon,Llist,Llabel,Lrrectangle,Ltextfield,Lcheckbox,Ltriangle,Lstring,Lscrollbar],right),
    Arc^width #= Button^width,
    %
    constrainSize(Comps),
    cgSame(Comps,window,Win),
    cgShow(Comps).

constrainSize([]).
constrainSize([C|Cs]):-
    C^height #>= 30,
    C^height #=< 80,
    constrainSize(Cs).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).











