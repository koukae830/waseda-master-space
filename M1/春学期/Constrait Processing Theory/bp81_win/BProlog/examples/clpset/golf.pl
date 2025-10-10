/**************************
Posting in comp.constraints and sci.op-research
describing this problem

warwick@cs.mu.oz.au (Warwick HARVEY) wrote:
>In sci.op-research, bigwind777@aol.com (Bigwind777) writes:
>
>>Please help with this problem.
>
>>I have 32 golfers, individual play.
>
>>We will golf for 16 weeks.
>
>>I want to set up the foursomes so each person only golfs
>>with the same person once.
>
>>How many weeks can we do this before it starts to duplicate ?
>.......
>It seems to be a generalisation of the problem of constructing a
>round-robin tournament schedule, where the number players in a "game" is
>more than two.
>
>Has anybody had any experience with this kind of problem?  Any ideas on
>good ways to model it?

*************************/

% For a 9-week solution to the above problem, call golf(9, 8, X).
go:-
    cputime(Start),
    top,
    cputime(End),        	
    T is End-Start,
    write('cputime='),write(T),nl.

top:-
    golf(9,8,X).
    
golf(RoundNum,RoundSize,Rounds) :-

	% MODEL PART

%	( for(I,1,4*RoundSize), foreach(I,SetOfAllPlayers) do true ),
	_978 is 4 * RoundSize, _957 is _978 + max(1 - _978, 1),
	do__1(1, _957, SetOfAllPlayers),

%	( for(_,1,RoundNum),
%	  foreach(GroupsInRound,Rounds),
%	  param(SetOfAllPlayers,RoundSize)
%	do
%	    ( foreach(S,GroupsInRound),
%	      for(_,1,RoundSize),
%	      param(SetOfAllPlayers)
%	    do
%		    S subset SetOfAllPlayers,
%		    #(S,4)
%	    ),  
%	    % all_union(GroupsInRound,SetOfAllPlayers),
%	    all_disjoint(GroupsInRound)
%	), 
	_1171 is RoundNum, _1150 is _1171 + max(1 - _1171, 1),
	do__2(1, _1150, Rounds, SetOfAllPlayers, RoundSize),

%	( fromto(Rounds,[R|Rest0],Rest0,[])
%	do
%		flatten(Rest0,Rest),
%		( foreach(Group,R),
%		  param(Rest)
%		do
%			( foreach(Group1,Rest),
%			  param(Group)
%			do
%				fd:(InCommon :: 0..1),
%				#(Group /\ Group1,InCommon)				
%			)
%		)
%	),
	do__4(Rounds),

	% SEARCH PART

%	( for(Player,1,4*RoundSize),
%	  param(Rounds)
%	do
%	    writeln(player = (Player)),
%	    ( foreach(R,Rounds),
%	      count(Round,1,_),
%	      param(Player)
%	    do
%		writeln(Round),
%	    	member(Group,R),
%		Player in Group
%	    )
%	),
	_2091 is 4 * RoundSize, _2070 is _2091 + max(1 - _2091, 1),
	do__7(1, _2070, Rounds),

	% PRINT OUT SOLUTION

%	( foreach(R,Rounds)
%	do
%		writeln(R)
%	).
	do__9(Rounds).

do__1(_959, _959, []) :-
        true,
        !.
do__1(_912, _953, [_912|_996]) :-
        +(_912, 1, _951),
        do__1(_951, _953, _996).

do__3([], _1321, _1321, _870) :-
        true,
        !.
do__3([_866|_1297], _880, _1315, _870) :-
        +(_880, 1, _1313),
%    write(_866 subset _870),nl,
%        _866 subset _870,
    list_to_set(_870,Temp),
    _866 :: {}..Temp,
        #(_866) #= 4,
        do__3(_1297, _1313, _1315, _870).

do__2(_1152, _1152, [], _870, _787) :-
        true,
        !.
do__2(_899, _1146, [_856|_1189], _870, _787) :-
        +(_899, 1, _1144),
        _1340 is _787,
        _1319 is _1340 + max(1 - _1340, 1),
        do__3(_856, 1, _1319, _870),
        clpset_all_disjoint(_856),
        do__2(_1144, _1146, _1189, _870, _787).

do__6([], _747) :-
        true,
        !.
do__6([_810|_1755], _747) :-
    _806 in 0..1,
        #(_747 /\ _810) #= _806,
        do__6(_1755, _747).

do__5([], _828) :-
        true,
        !.
do__5([_747|_1685], _828) :-
        do__6(_828, _747),
        do__5(_1685, _828).

do__4([]) :-
        true,
        !.
do__4([_724|_840]) :-
        flatten(_840, _828),
        do__5(_724, _828),
        do__4(_840).

do__8([], _2211, _2211, _748) :-
        true,
        !.
do__8([_724|_2192], _2215, _2205, _748) :-
        +(_2215, 1, _754),
        writeln(_754),
        mymember(_747, _724),
        _748 #<- _747,
        do__8(_2192, _754, _2205, _748).

do__7(_2072, _2072, _728) :-
        true,
        !.
do__7(_748, _2066, _728) :-
        +(_748, 1, _2064),
        writeln(player = _748),
        do__8(_728, 0, _766, _748),
        do__7(_2064, _2066, _728).

do__9([]) :-
        true,
        !.
do__9([_724|_2464]) :-
        writeln(_724),
        do__9(_2464).

+(X,Y,Z):- Z is X+Y.

flatten(L0,L):-
    flatten(L0,L,[]).

flatten([],L,LR):-true : L=LR.
flatten([P|Ps],L,LR):-true :
    flatten(P,L,L1),
    flatten(Ps,L1,LR).
flatten(P,L,LR):-L=[P|LR].

mymember(X,[X|_]).
mymember(X,[_|Xs]):-
%	increment_backtrack_nos,
	mymember(X,Xs).
