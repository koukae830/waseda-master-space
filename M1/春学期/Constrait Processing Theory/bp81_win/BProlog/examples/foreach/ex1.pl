go:-test.

% iterate through a range of integers
% from small to large
test:-
    writeln(test1),
    foreach(X in 1..5, writeln(X)),fail.

% make a list [1,2,3,4,5]
test:-
    writeln(test2),
    foreach(X in 1..5, ac1(L,[]), L^0=[X|L^1]),
    writeln(L),fail.

% make a list of length 5 (same as length(L,5))
test:-
    writeln(test3),
    foreach(X in 1..5, [E], ac(L,[]), L^1=[E|L^0]),
    writeln(L),fail.

test:-
    writeln(test4),
    L @= [1 : X in 1..5],
    writeln(L),fail.

test:-
    writeln(test5),
    L @= [Y : X in 1..5],
    writeln(L),fail.

% make a list [5,4,3,2,1]

test:-
    writeln(test6),
    foreach(X in 1..5, ac(L,[]), L^1=[X|L^0]),
    writeln(L),fail.

test:-
    writeln(test7),
    L @= [X : X in 1..5],
    writeln(L),fail.

% iterate through a list
test:-
    writeln(test8),
    foreach(X in [1,2,3], writeln(X)),fail.

% map a list to a list of opposite numbers [-1,-2,-3]
test:-
    writeln(test9),
    foreach(X in [1,2,3], [Y], ac1(Ys,[]), (Y is -X, Ys^0=[Y|Ys^1])),
    writeln(Ys),fail.

test:-
    writeln(test10),
    Ys @= [Y : X in [1,2,3], [Y],Y is -X],
    writeln(Ys),fail.

% sum a list
test:-
    writeln(test11),
    foreach(X in [1,2,3], ac(Sum,0), Sum^1 is Sum^0+X),
    writeln(Sum),fail.

% reverse a list
test:-
    writeln(test12),
    foreach(X in [1,2,3], ac(Rev,[]), Rev^1=[X|Rev^0]),
    writeln(Rev),fail.


% multiple loops
test:-
    writeln(test13),
    foreach(I in 1..3, J in 1..3, writeln((I,J))),fail.

% iterate through a list of pairs
test:-
    writeln(test14),
    L=[(1,a),(2,b),(3,c)],
    foreach((I,A) in L, writeln((I,A))),fail.

% copy a structure
test:-
    writeln(test15),
    S=f(a,b,c),
    functor(S,F,N), functor(S1,F,N),
    foreach(I in 1..N, [A], (arg(I,S,A),arg(I,S1,A))),
    writeln(S1),
    fail.

% iterate through a list of lists
test:-
    writeln(test16),
    Ls=[[1,2,3],[a,b,c]],
    foreach(L in Ls, E in L, writeln(E)),fail.

test:-
    writeln(test17),
    Ls=[[1,2,3],[a,b,c]],
    foreach(L in Ls, (foreach(E in L, write(E)),nl)),fail.

% make an association list
test:-
    writeln(test18),
    L1=[a,b,c],
    L2=[1,2,3],
    foreach((E1,E2) in (L1,L2),ac1(L,[]),L^0=[(E1,E2)|L^1]),
    writeln(L),fail.

test:-
    writeln(test19),
    L1=[a,b,c],
    L2=[1,2,3],
    L @= [(E1,E2) : (E1,E2) in (L1,L2)],
    writeln(L).











    
