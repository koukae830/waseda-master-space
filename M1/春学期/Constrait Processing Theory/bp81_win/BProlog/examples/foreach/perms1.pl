go:-
    perms([1,2,3,4],Ps),
    writeln(Ps).

% Xs=[X1,X2,...,Xn] Ys=[(X1,[X2,...,Xn]),(X2,[X1,X3,...,Xn]),...]
select([],[]).
select([X|Xs],Ys):-
    select(Xs,Zs),
    Ys1 @= [(Z,[X|ZsR]) : (Z,ZsR) in Zs],
    Ys=[(X,Xs)|Ys1].

perms([X],[[X]]).
perms(Xs,Ps):-
    select(Xs,Ys),
    Zs @= [(X,PsX) : (X,Rx) in Ys,[PsX],perms(Rx,PsX)], % PsX is local
    Ps @= [[X|P] : (X,PsX) in Zs,P in PsX].  
