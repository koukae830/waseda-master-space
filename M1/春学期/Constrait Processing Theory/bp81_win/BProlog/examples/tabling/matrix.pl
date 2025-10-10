/*  Taken from "Simplifying Dynamic Programming via Mode-directed Tabling"
    Software Practice and Experience, 38(1): 75-94, 2008, by Hai-Feng Guo, Gopal Gupta */

:- table sc(+,min,-,-).

sc([P1, P2], 0, P1, P2).
sc([P1, P2, P3 | Pr], V, P1, Pn) :-
    break([P1, P2, P3 | Pr], PL1, PL2, Pk),
    sc(PL1, V1, P1, Pk),
    sc(PL2, V2, Pk, Pn),
    V is V1 + V2 + P1 * Pk * Pn.

break([P1, P2, P3], [P1, P2], [P2, P3], P2).
break([P1, P2, P3, P4 | Pr], [P1, P2], [P2, P3, P4 | Pr], P2).
break([P1, P2, P3, P4 | Pr], [P1 | L1], L2, Pk) :-
    break([P2, P3, P4 | Pr], L1, L2, Pk).

go :- 
   statistics(_, _),
   sc([50, 10, 400, 30, 30, 20, 10, 5, 30, 20, 
      6, 20, 20, 30, 9, 30, 20, 500, 20, 40,
      30, 8, 3, 5, 9, 200, 10, 400, 20, 30,
     56, 14, 430, 60, 35, 25, 15, 5, 35, 25,
      50, 10, 400, 30, 30, 20, 10, 5, 30, 20,
      35, 18, 32, 54, 94, 250, 70, 200, 50, 70,
       6, 20, 20, 30, 9, 30, 20, 500, 20, 40,
     80, 26, 405, 20, 70, 40, 90, 15, 20, 30,
       6, 20, 20, 30, 9, 30, 20, 500, 20, 40,
      30, 8, 3, 5, 9, 200, 10, 400, 20, 30], V, 50, 30),
   statistics(_, [_, B]),
   write('Scalar Multiplication is '), write(V), nl,
   write('execution time = '), write(B), write(' ms'), nl.
