/* sendmoney */
go:-
    statistics(runtime,_),
    range(0,9,D),
    vars_constraints(Vars),
    label(Vars,D),
    write(Vars),
    statistics(runtime,[_,T]),
    write('execution time is '),write(T), write(milliseconds).

vars_constraints(Vars):-
    Vars=[S,E,N,D,M,O,R,Y],
    neq_zero(S),
    neq_zero(M),
    equal(R1,M),
    add(R2,S,M,R1,O),
    add(R3,E,O,R2,N),
    add(R4,N,R,R3,E),
    add(0,D,E,R4,Y),
    Carry = [0,1],
    member(R1,Carry),
    member(R2,Carry),
    member(R3,Carry),
    member(R4,Carry).

label([],_).
label([V|Vs],D):-
    myselect(D,Rest,V),
    label(Vs,Rest).

range(N,N,[N]) :- !.
range(M,N,[M|Ns]) :-
	M < N,
	M1 is M+1,
	range(M1,N,Ns).

myselect([X|Xs],Xs,X).
myselect([Y|Ys],[Y|Zs],X) :- myselect(Ys,Zs,X).


neq_zero(X),var(X),{ins(X)} => true.
neq_zero(X):-true : X=\=0.

equal(X,Y),var(X),{ins(X),ins(Y)} => true.
equal(X,Y),var(Y),{ins(Y)} => true.
equal(X,Y):-true : X=:=Y.

add(C,X,Y,NewC,Z),var(C),{ins(C),ins(X),ins(Y),ins(NewC),ins(Z)} => true.
add(C,X,Y,NewC,Z),var(X),{ins(X),ins(Y),ins(NewC),ins(Z)} => true.
add(C,X,Y,NewC,Z),var(Y),{ins(Y),ins(NewC),ins(Z)} => true.
add(C,X,Y,NewC,Z),var(NewC),{ins(NewC),ins(Z)} => true.
add(C,X,Y,NewC,Z),var(Z),{ins(Z)} => true.
add(C,X,Y,NewC,Z):-true : C+X+Y=:=10*NewC+Z.



