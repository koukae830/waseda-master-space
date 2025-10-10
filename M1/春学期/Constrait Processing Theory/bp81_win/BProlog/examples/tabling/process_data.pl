go:-
    open(time_xsb,read,Txsb),  
    read_data(Txsb,Times_xsb),
    open(time_bp,read,Tbp),
    read_data(Tbp,Times_bp),
    open(space_bp,read,Sbp),
    read_data(Sbp,Spaces_bp),
    open(space_xsb,read,Sxsb),
    read_data(Sxsb,Spaces_xsb),
    compute(Times_xsb,Times_bp,Spaces_xsb,Spaces_bp,Res),
    output_program_names(Res),
    output_res(Res).

read_data(S,Data):-
    read(S,Item),
    read_data(S,Item,Data).

read_data(S,end_of_file,Data):-!,close(S),Data=[].
read_data(S,Item,Data):-
    Data=[Item|Data1],
    read(S,NewItem),
    read_data(S,NewItem,Data1).

compute([],[],[],[],Res):-!,Res=[].
compute([Time_xsb|Times_xsb],[Time_bp|Times_bp],[Space_xsb|Spaces_xsb],[Space_bp|Spaces_bp],Res):-
    functor(Time_xsb,Prog,_),
    ratioTime(Time_xsb,Time_bp,RatioTime),
    ratioSpace(Space_xsb,Space_bp,RatioSpace),
    Res=[res(Prog,RatioTime,RatioSpace)|Res1],
    compute(Times_xsb,Times_bp,Spaces_xsb,Spaces_bp,Res1).

ratioTime(Xsb,Bp,Ratio):-
    arg(1,Xsb,Time_xsb),
    arg(1,Bp,Time_bp),
    Ratio is Time_xsb/Time_bp.

ratioSpace(Xsb,Bp,Ratio):-    
    Xsb=..[_,X1,X2,X3,X4,X5],
    Bp=..[_,B1,B2,B3],
    Total_xsb is X1+X2+X3+X4+X5,
    Total_bp is (B1+B2+B3),
    Ratio is Total_bp/Total_xsb.

output_res([]).
output_res([R|Rs]):-
    R=res(Prog,TimeRatio,SpaceRatio),
/*
    TimeInt is truncate(TimeRatio), 
    TimeDec is round((TimeRatio*100)) mod 100,
    write(TimeInt),write('.'),write(TimeDec),
    write(' & '),
*/
    write(SpaceRatio),
    (Rs==[]->
     write(' \\ \hline '),nl;    
     write(' & ')),
    output_res(Rs).

output_program_names([]).
output_program_names([R|Rs]):-
    R=res(Prog,TimeRatio,SpaceRatio),
    write(time), write(' & '), write(space), 
    (Rs==[]->
     write(' \\ \hline '),nl;    
     write(' & ')),
    output_program_names(Rs).

/*    
go:-
    p(Name,E,C,H,T),
    E1 is E-552,
    C1 is C-544,
    H1 is H-280,
    T1 is T-64,
    Control is E1+C1,
    Total is Control+H1+T1,
    %
    p(Name,_C,_H,_T),
    (_C-42>0 -> _C1 is 4*(_C-42); _C1=0),
    (_H-16>0 ->_H1 is 4*(_H-16); _H1=0),
    _T1 is 4*_T,
    _Total is _C1+_H1+_T1,
    write(Name),write(' & '),
    write(_C1),write(' & '),
    write(_H1),write(' & '),
    write(_T1),write(' & '),
    write(Control),write(' & '),
    write(H1),write(' & '),
    write(T1),write(' & '),
    Ratio is round(100*Total/_Total)/100,
    write(Ratio),
    write(' \\ \hline '),nl,    
    fail.
    
go_xsb:-
    p(Name,E,C,H,T),
    E1 is E-552,
    C1 is C-544,
    H1 is H-280,
    T1 is T-64,
    Control is E1+C1,
    Total is Control+H1+T1,
    write(Name),write(' & '),
    write(Control),write(' & '),
    write(H1),write(' & '),
    write(T1),write(' & '),
    write(Total), write(' \\ \hline '),nl,
    fail.
go_bp:-
    p(Name,C,H,T),
    C1 is 4*(C-42),
    H1 is 4*H,
    T1 is 4*T,
    Total is C1+H1+T1,
    write(Name),write(' & '),
    write(C1),write(' & '),
    write(H1),write(' & '),
    write(T1),write(' & '),
    write(Total),write(' \\ \hline '),nl,
    fail.
    
*/
