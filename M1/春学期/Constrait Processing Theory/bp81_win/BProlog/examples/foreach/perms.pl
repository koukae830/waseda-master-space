go:-
    perms([1,2,3,4],Ps),
    writeln(Ps).

perms([],[[]]).
perms([X|Xs],Ps):-
    perms(Xs,Ps1),
    Ps @= [P : P1 in Ps1, I in 0..Xs^length,[P],insert(X,I,P1,P)].

% insert(X,I,L1,L): insert X into L1 in Ith position to get L
insert(X,0,L,[X|L]).
insert(X,I,[Y|L1],[Y|L]):-
    I>0,
    I1 is I-1,
    insert(X,I1,L1,L).
