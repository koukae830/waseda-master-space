/* 
    Taken from "Simplifying Dynamic Programming via Mode-directed Tabling"
    Software Practice and Experience, 38(1): 75-94, 2008, by Hai-Feng Guo, Gopal Gupta 
*/

% Optimal Binary Search Tree
:- table obst(+, min, -).

obst(A, B, B) :- base(A, B).
obst([F1, F2 |L], N, T) :-
    break([F1, F2 | L], L1, L2, (W, P)),
    obst(L1, N1, T1),
    obst(L2, N2, T2),
    T is T1 + T2 + P,
    N is T + N1 + N2.

base([], 0).
base([(W, P)], P).

break([F], [], [], F).
break([F1, F2 | L], [], [F2 | L], F1).
break([F1, F2 | L], [F1 | L1], L2, F) :-
    break([F2 | L], L1, L2, F).


go :- 
   statistics(_, _),
   obst([(a, 22), (am, 18), (and, 20), (egg, 5), (if, 25), 
   (a, 2), (am, 7), (and, 20), (egg, 5), (if, 25),   
   (a, 12), (am, 8), (and, 4), (egg, 5), (if, 5),   
   (a, 22), (am, 10), (and, 20), (egg, 15), (if, 25),   
   (a, 32), (am, 20), (and, 23), (egg, 5), (if, 25),   
   (a, 42), (am, 4), (and, 20), (egg, 5), (if, 5),   
   (a, 32), (am, 18), (and, 3), (egg, 15), (if, 25),   
   (a, 23), (am, 19), (and, 20), (egg, 5), (if, 5),   
   (a, 24), (am, 9), (and, 20), (egg, 15), (if, 25),   
   (a, 21), (am, 38), (and, 20), (egg, 5), (if, 5),   
   (a, 2), (am, 8), (and, 21), (egg, 5), (if, 25),   
   (a, 16), (am, 18), (and, 20), (egg, 5), (if, 25),   
   (the, 2), (two, 8)], N, _T),
   statistics(_, [_, B]),
   write('Optimal value is '), write(N), nl,
   write('execution time = '), write(B), write(' ms'), nl.

