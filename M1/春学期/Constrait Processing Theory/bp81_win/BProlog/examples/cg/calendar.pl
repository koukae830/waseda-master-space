/*  Copyright (C) Afany Software All rights reserved 
    This program displays a calendar and allows the user to input, save and load schedules
*/

main:-
    initialize_bp,
    go(Cal),
    openCalendar(Cal,'c:/BProlog/examples/cg/2004'),
    $event_watching_loop.

go:-
    go(_).

go(Cal):-
    cgWindow(Win,"Calendar"), Win^width #= 800, Win^height #= 800,
    Win^topMargin #= 50, Win^leftMargin #= 20,
    handleClose(Win),
    % set up menus
    cgMenu([File,Help],["File","Help"]),
    cgMenuItem([Open,Save],["Open","Save"]),
    cgAdd(File,[Open,Save]),
    cgSetMenuBar(Win,MB),
    cgAdd(MB,[File,Help]),
    % set title
    date(Year,Month,_),
    titleString(Year,Month,TString),
    cgLabel(Title,TString),Title^fontSize #= 20,
    Title^centerX #= Win^centerX,
    cgButton([Pre,Next],["  <=  ","  =>  "]),
    cgSame([Pre,Next],fontSize,16),
    cgTable([[Title,Title],[Pre,Next]],5,5),
    cgSame([Title,Pre,Next],window,Win),
    % set week labels
    cgRectangle(Rect),Rect^color #= lightGray,Rect^window #= Win,
    Weeks=[Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday],
    cgLabel(Weeks,["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]),
    cgTable([Weeks]),
    cgSetAlignment(Weeks,center),
    cgSame(Weeks,fontSize,16),
    cgSame(Weeks,fontStyle,bold),
    Width #= 100,
    Height #= 60,
    cgSame(Weeks,width,100),
    cgSame(Weeks,height,50),
    cgSame(Weeks,window,Win),
    cgSame([Rect|Weeks],y,Y0),Y0 #= Next^bottomY+10,
    Rect^x #= Monday^x, Rect^width #= 7*Width,
    Title^centerX #= Thursday^centerX,
    cgShow([Title,Pre,Next,Rect|Weeks]), 
    Cal=calendar(Win,Year,Month,Memo),
    Rect^x #= StartX, Rect^bottomY+40 #= StartY,
    newCalendar(Year,Month,Cal,StartX,StartY,Width,Height),
    handlePrev(Pre,Cal,Title),
    handleNext(Next,Cal,Title),
    handleSave(Save,Cal),
    handleOpen(Open,Cal),
    showOrCleanCalendarBody(Cal,show).

titleString(Year,Month,TString):-
    number_codes(Month,MonthString),
    (MonthString=[M]->MonthString1=[0'0,M];MonthString1=MonthString),
    number_codes(Year,YearString),
    append(MonthString1,[0'/|YearString],TString).

handleClose(Win),{windowClosing(Win)} => cgClose(Win).

handlePrev(Pre,Cal,Title),{actionPerformed(Pre)} =>
    showMonth(Cal,-1,Title).

handleNext(Next,Cal,Title),{actionPerformed(Next)} =>
    showMonth(Cal,1,Title).

%%
newCalendar(Year,Month,Cal,StartX,StartY,Width,Height):-
    Cal=calendar(Win,_Year,_Month,_Memo),
    setarg(2,Cal,Year),
    setarg(3,Cal,Month),
    new_array(Memo,[12]),
    setarg(4,Cal,Memo),
    % create reference rectangles
    new_array(A,[6,7]),
    array_to_list(A,Rects), 
    cgRectangle(Rects), 
    cgSame(Rects,width,Width),
    cgSame(Rects,height,Height),
    cgSame(Rects,window,Win),
    cgSame(Rects,fill,0),
    A^[1,1] @= Rect0,
    Rect0^x #= StartX, Rect0^y #= StartY,
    cgTable(A), 
    cgShow(Rects),
    createMemo(Win,Memo,Year,1,A).

createMemo(Win,Memo,Year,M0,A):-M0>12,!.
createMemo(Win,Memo,Year,M0,A):-
    Memo^[M0] @= MonthMemo,
    number_of_days(Year,M0,Max),
    new_array(MonthMemo,[Max]),
    createMonthMemo(Win,MonthMemo,Year,M0,1,Max,A),
    M1 is M0+1,
    createMemo(Win,Memo,Year,M1,A).

createMonthMemo(Win,MonthMemo,Year,Month,D0,Max,A):-D0>Max,!.
createMonthMemo(Win,MonthMemo,Year,Month,D0,Max,A):-
    MonthMemo^[D0] @= DayMemo,
    DayMemo=memo(Lab,TextArea),
    day_week(Year,Month,1,Column0),
    day_week(Year,Month,D0,Column),
    Row is (D0+Column0-2)//7+1,
    A^[Row,Column] @= Rect,
    cgLabel(Lab),Lab^fontSize #= 14, 
    cgTextArea(TextArea),TextArea^color #= red,
    number_codes(D0,DString),
    cgSetText(Lab,DString),
    cgSame([Lab,TextArea],window,Win),
    Lab^centerX #= Rect^centerX, Lab^y #= Rect^y+1,
    cgPack(Lab),
    TextArea^x #= Rect^x+1, TextArea^y #= Lab^bottomY,
    TextArea^width #= Rect^width-2,
    TextArea^height #= Rect^height-Lab^height-2,
    D1 is D0+1,
    createMonthMemo(Win,MonthMemo,Year,Month,D1,Max,A).

showMonth(Cal,-1,Title):-
    Cal=calendar(Win,Year,1,Memo),!.
showMonth(Cal,1,Title):-
    Cal=calendar(Win,Year,12,Memo),!.
showMonth(Cal,Dif,Title):-
    Cal=calendar(Win,Year,Month,Memo),
    showOrCleanCalendarBody(Cal,clean),
    Month1 is Month+Dif,
    setarg(3,Cal,Month1),
    titleString(Year,Month1,TString),
    cgSetText(Title,TString),
    cgShow(Title),!,
    showOrCleanCalendarBody(Cal,show).

showOrCleanCalendarBody(Cal,Action):-
    Cal=calendar(Win,Year,Month,Memo),
    number_of_days(Year,Month,Max),
    Memo^[Month] @= MonthMemo,
    showOrCleanMemos(MonthMemo,1,Max,Action).

showOrCleanMemos(MonthMemo,Dno,DMax,Action):-Dno=<DMax,!,
    MonthMemo^[Dno] @= memo(Lab,TextArea),
    (Action==show->cgShow([Lab,TextArea]);
     cgSetVisible([Lab,TextArea],0)),
    Dno1 is Dno+1,
    showOrCleanMemos(MonthMemo,Dno1,DMax,Action).
showOrCleanMemos(MonthMemo,Dno,DMax,Action).

number_of_days(Year,2,NoDays):-
   leap_year(Year),!,
   NoDays=29.
number_of_days(Year,2,NoDays):-
   NoDays=28.
number_of_days(Year,1,31):-!.
number_of_days(Year,3,31):-!.
number_of_days(Year,5,31):-!.
number_of_days(Year,7,31):-!.
number_of_days(Year,8,31):-!.
number_of_days(Year,10,31):-!.
number_of_days(Year,12,31):-!.
number_of_days(Year,Month,30).

leap_year(Year):-
    Year mod 1000 =:=0,!.
leap_year(Year):-
    Year mod 100 =:= 0, Year mod 400 =\= 0,!.
leap_year(Year):-
    Year mod 4 =:=0.

day_week(Year,Month,Day,WeekDay):- % 1/1/2001 is Monday
   (date_before(Year,Month,Day,2001,1,1)->
   count_days(Year,Month,Day,200,12,31,NoDays),
   WeekDay is 7-NoDays mod 7;
   count_days(2001,1,1,Year,Month,Day,NoDays),
   WeekDay is NoDays mod 7 +1).


date_before(Year,Month,Day,Year1,Month1,Day1):-Year<Year1,!.
date_before(Year,Month,Day,Year1,Month1,Day1):-Year=:=Year1,Month<Month1,!.
date_before(Year,Month,Day,Year1,Month1,Day1):-Year=:=Year1,Month=:=Month1,Day<Day1.

count_days(Year0,Month0,Day0,Year,Month,Day,NoDays):-
   count_days(Year0,Month0,Day0,Year,Month,Day,0,NoDays).

count_days(Year0,Month0,Day0,Year,Month,Day,NoDays0,NoDays):-
   Year0<Year,!,
   NoDays1 is NoDays0+1,
   count_days1(Year0,Month0,Day0,12,31,NoDays1,NoDays2),
   Year1 is Year0+1,
   count_days(Year1,1,1,Year,Month,Day,NoDays2,NoDays).
count_days(Year0,Month0,Day0,Year,Month,Day,NoDays0,NoDays):-
   count_days1(Year0,Month0,Day0,Month,Day,NoDays0,NoDays).

%same year
count_days1(Year,Month0,Day0,Month,Day,NoDays0,NoDays):-Month0<Month,!,
   number_of_days(Year,Month0,NoDaysInMonth0),
   NoDays1 is NoDays0+NoDaysInMonth0-Day0+1,
   Month1 is Month0+1,
   count_days1(Year,Month1,1,Month,Day,NoDays1,NoDays).
count_days1(Year,Month0,Day0,Month,Day,NoDays0,NoDays):-
   NoDays is NoDays0+Day-Day0.

%%
handleSave(Save,Cal),{actionPerformed(Save)} =>
   saveCalendar(Cal).

saveCalendar(Cal):-
    Cal=calendar(Win,Year,Month,Memo),
    askFileName(Win,save,FileNameString),
    (var(FileNameString)->true;
     atom_codes(FileName,FileNameString),
     saveCalendar(Year,Memo,FileName)).

saveCalendar(Year,Memo,FileName):-
    tell(FileName),
    saveCalendarMonths(Year,1,Memo),
    told.

saveCalendarMonths(Year,Month,Memo):-Month>12,!.
saveCalendarMonths(Year,Month,Memo):-
    Memo^[Month] @= MonthMemo,
    MonthMemo^length @= Max,
    saveCalendarDays(Year,Month,1,Max,MonthMemo),
    Month1 is Month+1,
    saveCalendarMonths(Year,Month1,Memo).

saveCalendarDays(Year,Month,Day,Max,Memo):-Day>Max,!.
saveCalendarDays(Year,Month,Day,Max,Memo):-
    Memo^[Day] @= memo(Lab,TextArea),
    cgGetText(TextArea,String),
    (String=""->true; write(Year/Month/Day/String),write('.'),nl),
    Day1 is Day+1,
    saveCalendarDays(Year,Month,Day1,Max,Memo).

askFileName(Win,Mode,FileNameString):-
    cgFileDialog(FileDialog),FileDialog^mode #= Mode,
    FileDialog^parent #= Win,
    cgShow(FileDialog),
    cgGetDirectory(FileDialog, Dir),
    cgGetFile(FileDialog,File),
    ((nonvar(Dir),nonvar(File))->
     append(Dir,File,FileNameString),
     name(FullName,FileNameString),
     write('+*****name'),write(FullName),nl;
     true).

handleOpen(Open,Cal),{actionPerformed(Open)} =>
    openCalendar(Cal).

openCalendar(Cal):-
    Cal=calendar(Win,Year,Month,Memo),
    askFileName(Win,load,FileNameString),
    (var(FileNameString)->true;
     atom_codes(FileName,FileNameString),
     openCalendar(Cal,FileName)).

openCalendar(Cal,FileName):-
    see(FileName),
    read(Line),
    openCalendarMemo(Line,Cal),
    seen,
    showOrCleanCalendarBody(Cal,show).

openCalendarMemo(end_of_file,Cal):-!.
openCalendarMemo(Year/Month/Day/DayMemo,Cal):-
    Cal=calendar(Win,_Year,_Month,Memo),
    setarg(2,Cal,Year),
    Memo^[Month,Day] @= memo(Lab,TextArea),
    cgSetText(TextArea,DayMemo),
    read(Line),
    openCalendarMemo(Line,Cal).

