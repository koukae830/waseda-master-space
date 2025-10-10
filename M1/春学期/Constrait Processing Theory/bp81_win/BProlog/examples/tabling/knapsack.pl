/*  Taken from "Simplifying Dynamic Programming via Mode-directed Tabling"
    Software Practice and Experience, 38(1): 75-94, 2008, by Hai-Feng Guo, Gopal Gupta */
% Knapsack Problem
:- table knapsack(+, +, max).
knapsack(_, 0, 0).
knapsack([_ | L], K, V) :-
    knapsack(L, K, V).
knapsack([F | L], K, V) :-
    K1 is K - F,
    K1 >= 0,
    knapsack(L, K1, V1),
    V is V1 + 1.

go :-
   statistics(_, _),
   knapsack([50, 10, 400, 30, 30, 20, 10, 5, 30, 20,
       6, 20, 20, 30, 9, 30, 20, 500, 20, 40,
      30, 8, 3, 5, 9, 200, 10, 400, 20, 30,
      50, 10, 400, 30, 30, 20, 10, 5, 30, 20,
       6, 20, 20, 30, 9, 30, 20, 500, 20, 40,
       6, 20, 20, 30, 9, 30, 20, 500, 20, 40,
      30, 8, 3, 5, 9, 200, 10, 400, 20, 30,
      50, 10, 400, 30, 30, 20, 10, 5, 30, 20,
       6, 20, 20, 30, 9, 30, 20, 500, 20, 40,
      30, 8, 3, 5, 9, 200, 10, 400, 20, 30], 4000, V),
   statistics(_, [_, B]),
   write('There is a solution for this knapsack problem'), nl,
   write('The maximal number of items is '), write(V), nl,
   write('execution time = '), write(B), write(' ms'), nl.

