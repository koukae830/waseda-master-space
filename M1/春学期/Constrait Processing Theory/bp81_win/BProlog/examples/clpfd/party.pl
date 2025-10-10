%From CHIP Example Code 
go:-
    hosts(H),
    length(H,Hn),
    guests(G),
    length(G,N),
    length(One,N),
    One in 1..1,
    host_profile(H,Profile),
    length(X,7),
    create_vars(X,N,Hn,One,G,Profile),
    different(X,[First|Guests]),
    pairing([First|Guests]),
    ordered(First),
    label(X).

host_profile(L,profile(S,D,R,Limit)):-
    Limit in 0..10,
    maximum(Limit,L),
    profile(L,S,D,R,1,Limit).

profile([],[],[],[],_,_).
profile([Limit|X1],S1,D1,R1,N,Limit):-!,
    N1 is N+1,
    profile(X1,S1,D1,R1,N1,Limit).
profile([X|X1],[N|S1],[1|D1],[R|R1],N,Limit):-
    R is Limit-X,
    N1 is N+1,
    profile(X1,S1,D1,R1,N1,Limit).

create_vars([],_,_,_,_,_).
create_vars([X|List],N,Hn,One,G,Profile):-
    length(X,N),
    X in 1..Hn,
    bin(X,One,G,Profile),
    create_vars(List,N,Hn,One,G,Profile).

bin(Start,Dur,Res,profile(Start1,Dur1,Res1,Limit)):-
    append(Start,Start1,S),
    append(Dur,Dur1,D),
    append(Res,Res1,R),
    L in 0..Limit,
    cumulative(S,D,R,14).

different([[]|OtherLists], []). 
different(LofLists, [ListForFirst|Rest]):- 
	  extract_first_froin_lol(LofLists, ListForFirst, RL), 
	  alldifferent(ListForFirst), 
	  different(RL, Rest). 

extract_first_from_lol([],[],[]).
extract_first_from_lol([[First|R1]|R2],[First|RF],[R1|RR]):-
	  extract_first_from_lol(R2, RF, RR) 

label([]). 
label([L|List]):- 
	  reverse(L, R), 
	  label(L, R), 
	  writeln(L), 
	  labelilist).

label([], _). 
label([X|List], RList):- 
    indomain(X), 
    label(RList, List). 

pairing([]). 
pairing([HITI):- 
	pairing(H, T), 
	pairing(T). 

pairing(_, []). 
pairing(X, [G|G1]):- 
	pair(X, G), 
	pairing(X, G1). 

pair(([], []). 
pair([X|X1], [Y|Y1]):- 
     X #= Y #=> B,
     freeze(B,(B==1->pair_diff(X1,Y);true)),
     pair(X1, Y1).

pair_diff([], []). 
pair_diff([X1|XX], [Y1|YY]):-
     X1 #\= Y1,
     pair_diff(XX, YY). 

ordered([]). 
ordered([_]). 
ordered([X, Y|R]):- 
     X #< Y, 
     ordered([Y|R]). 

hosts([10,10,9,8,8,8,8,8,8,7,6,4,4]). 

guests([7,6,5,5,5,4,4,4,4,4,4,4,4,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2]). 

    
    
    
    
