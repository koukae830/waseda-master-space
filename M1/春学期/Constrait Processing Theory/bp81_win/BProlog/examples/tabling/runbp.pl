go:-
    open(res_bp,write,S),
    run(S).

profile:-
    open(profile_bp_refs,write,S1),
    open(profile_bp_space,write,S2),
    start_click,
    not_not_dummy,
    access_counters(_,Dx,Dy,Dl,Dh,Dt,Dc),
    profile(S1,S2,Dx,Dy,Dl,Dh,Dt,Dc).
profile.

profile_one:-
    start_click,
    top,
    access_counters(I,X,Y,L,H,T,C),
    write(access_counters(I,X,Y,L,H,T,C)),nl.

profile(S1,S2,Dx,Dy,Dl,Dh,Dt,Dc):-
    programs(Ps),
    '$member'(PN,Ps),
    PN=(P,_),
    load(P),
    start_click,
    not_not_top,
    access_counters(_,X,Y,L,H,T,C),
    Refer_x is X-Dx,
    Refer_y is Y-Dy,
    Local is L-Dl,
    Heap is H-Dh,
    Trail is T-Dt,
    Choice is C-Dc,
    _xy is Refer_x + Refer_y,
    _x2y is Refer_x + Refer_y*2,
    _x3y is Refer_x + Refer_y*3,
    _x4y is Refer_x + Refer_y*4,
    write(S1,P),write(S1,'('),
    write_ln(S1,[Refer_x,Refer_y,_xy,_x2y,_x3y,_x4y],',',').'),
    write(S2,P),write(S2,'('),
    Control is Local+Choice,
    write_ln(S2,[Control,Heap,Trail],',',').'),
    fail.
profile(S1,S2,Dx,Dy,Dl,Dh,Dt,Dc):-close(S1),close(S2).


all_profile:-
    programs(Ps),
    start_click,
    '$member'((P,N),Ps),
    load(P),
    not_not_top,
    fail.
all_profile:-
    print_counters.

compall:-
    programs(Ps),
    '$member'((P,N),Ps),
    not(not($bpc$(P))),
    fail.
compall.

run(S):-
    programs(Ps),
    '$member'((P,N),Ps),
    run_program(P,N,S),
    fail.
run(S):-close(S).

run_program(P,N,S):-
%    compile(P),
    load(P),
    ntimes(N,T),!,
    write(S,P),write(S,'('), T1 is T/N, write(S,T1), write(S,').'),nl(S).

ntimes(N,T):-
    statistics(runtime,_),
    ntimes(N),
    statistics(runtime,[_,T1]),
    ntimes_dummy(N),
    statistics(runtime,[_,T2]),
    T is T1-T2.
    
ntimes(N):-N=:=0,!.
ntimes(N):-not_not_top, !, N1 is N-1,ntimes(N1).

ntimes_dummy(N):-N=:=0,!.
ntimes_dummy(N):-not_not_dummy, !, N1 is N-1,ntimes_dummy(N1).

not_not_top:-not_top,!,fail.
not_not_top.

not_top:-top,!,fail.
not_top.

not_not_dummy:-not_dummy,!,fail.
not_not_dummy.

not_dummy:-dummy,!,fail.
not_dummy.

dummy.

combine(Fs):-
    combine(Fs,[]).
combine(Fs).

combine([],L):-
    member(X,L),write(X),write('.'),nl,fail.
combine([F|Fs],L0):-
    readall(F,L,_),
    combine(L0,L,L1),
    combine(Fs,L1).

combine([],L,L).
combine([E1|L1],[E2|L2],[E3|L3]):-
    E1=..[F|Args1],
    E2=..[F|Args2],
    append(Args1,Args2,Args3),
    E3=..[F|Args3],
    combine(L1,L2,L3).

ratios(F1,F2):-
    readall(F1,L1,N),
    readall(F2,L2,N),
    functor(Sum,sum,N),
    initialize_structure(Sum,1,N,0),
    compute_ratios(L1,L2,0,Sum).

readall(F,L,N):-
    see(F),
    read(X),
    functor(X,_,N),
    read_data(X,L).

read_data(end_of_file,L):-!,L=[],seen.
read_data(X,L):-
    L=[X|L1],
    read(NewX),
    read_data(NewX,L1).

compute_ratios([],[],N,Sum):-
    functor(Sum,_,Arity),
    functor(Mean,mean,Arity),
    compute_mean(N,Sum,Mean,Arity),
    Mean =..[_|As],
    write_ln(user_output,['<mean>'|As],' & ',' \\ \hline').
compute_ratios([X|Xs],[Y|Ys],N,Sum):-
    functor(X,Program,Arity),
    functor(Ratio,ratio,Arity),
    functor(Sum1,sum,Arity),
    compute_ratio(Program,Arity,X,Y,Ratio,Sum,Sum1),
    N1 is N+1,
    compute_ratios(Xs,Ys,N1,Sum1).
    
compute_ratio(Program,I,X,Y,Ratio,Sum0,Sum):-
    I=:=0,!,
    Ratio=..[_|As],
    write_ln(user_output,[Program|As],' & ',' \\ \hline').
compute_ratio(Program,I,X,Y,Ratio,Sum0,Sum):-
    arg(I,X,Ax),
    arg(I,Y,Ay),
    (Ay=\=0->R is Ax/Ay;R=1),
    RoundR is round(R*100)/100,
    arg(I,Ratio,RoundR),
    arg(I,Sum0,A),
    sum(RoundR,A,SumA),
    arg(I,Sum,SumA),
    I1 is I-1,
    compute_ratio(Program,I1,X,Y,Ratio,Sum0,Sum).

sum(Elm,Sum0,Sum):-
    Sum is 1/Elm+Sum0.
mean(Sum,N,Mean):-
    Mean is round(N/Sum*1000)/1000.
/*
sum(Elm,Sum0,Sum):-
    Sum is Elm+Sum0.
mean(Sum,N,Mean):-
    Mean is round(Sum/N*1000)/1000.
*/

compute_mean(Total,Sum,Mean,I):-
    I=:=0,!.
compute_mean(Total,Sum,Mean,I):-
    arg(I,Sum,SumA),
    mean(SumA,Total,Temp),
    arg(I,Mean,Temp),
    I1 is I-1,
    compute_mean(Total,Sum,Mean,I1).
    
programs(Ps):-
    Ps=[
     (cs_o,1),
     (cs_r,1),
     (disj,1),
%     (farmer,1),
     (fib,1),
     (gabriel,1),
     (kalah,1),
     (peep,1),
     (pg,1),
     (read,1),
     (sg,1),
     (transitiveLeft,1),
     (transitiveRight,1)].
%     (water,1)].

'$member'(X,[X1|Xs]):-
    X=X1.
'$member'(X,[X1|Xs]):-
    '$member'(X,Xs).

write_ln(S,[],Dem,End):- write(S,End),nl(S).
write_ln(S,[X],Dem,End):-!,write_item(S,X),write(S,End),nl(S).
write_ln(S,[X|Xs],Dem,End):-write_item(S,X),write(S,Dem), write_ln(S,Xs,Dem,End).

write_item(S,X):-atom(X),!,atom_length(X,N),
    Tab is 20-N,
    write(S,X),spaces(S,Tab).
write_item(S,X):-write(S,X).

spaces(S,Tab):-Tab>0,!,write(S,' '),Tab1 is Tab-1,spaces(S,Tab1).
spaces(S,Tab).


initialize_structure(Sum,N0,N,Value):-
    N0=<N,!,
    arg(N0,Sum,Value),
    N1 is N0+1,
    initialize_structure(Sum,N1,N,Value).
initialize_structure(Sum,N0,N,Value).



    
summary:-
    command(system('cat profile_sp_refs')),
    command(system('cat profile_bp_refs')),
    command(ratios(profile_sp_refs,profile_bp_refs)),

    command(system('cat profile_sp_space')),
    command(system('cat profile_bp_space')),
    command(ratios(profile_sp_space,profile_bp_space)),
    
    command(system('cat res_sp_cc_orchid')),
    command(system('cat res_bp_cc_orchid')),
    command(ratios(res_sp_cc_orchid,res_bp_cc_orchid)),

    command(system('cat res_sp_cc_maroon')),
    command(system('cat res_bp_cc_maroon')),
    command(ratios(res_sp_cc_maroon,res_bp_cc_maroon)),

    command(system('cat res_sp_nc_orchid')),
    command(system('cat res_bp_cc_orchid')),
    command(ratios(res_sp_nc_orchid,res_bp_cc_orchid)),

    command(system('cat res_sp_nc_maroon')),
    command(system('cat res_bp_cc_maroon')),
    command(ratios(res_sp_nc_maroon,res_bp_cc_maroon)).

command(X):-nl,write(X),nl,
    call(X).

