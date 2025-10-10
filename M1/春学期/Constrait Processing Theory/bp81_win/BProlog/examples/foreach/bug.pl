perms([X|Xs],Ps):-
    perms(Xs,Ps1),
    Ps @= [P : P1 in Ps1, I in 0..Xs^length,[P],insert(X,I,P1,P)].
