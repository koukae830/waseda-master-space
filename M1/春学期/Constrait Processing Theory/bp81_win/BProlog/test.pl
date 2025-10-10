/* Lecture1 */
human(yoshie).
human(fujimura).
human(lepage).

mortal(X):-human(X).

animal(rabbit).
animal(tiger).
animal(dog).

/* Lecture2 */
father(kiyoshi,osamu).
father(kiyoshi,kyoko).
father(takuji,kiyoshi).

brother(X,Y):-
    father(F,X),
    father(F,Y).

/*
ancestor(A,C):-
    father(B1,C),
    father(B2,B1),
    father(B3,B2),
    .... undefined generations?
    father(A,)    
*/    

ancestor(A,C):-
    father(A,X),
    ancestor(X,C).


/* Lecture4 */
/*
    | ?- member(X,[1,2,3]).
    X = 1 ?;
    X = 2 ?;
    X = 3 ?
    yes
    | ?- member(X,[1,2,3]).
    X = 1 ?;
    X = 2 ?;
    X = 3 ?;
    no
    | ?- [1,2,3,4]=[X,Y,Z,T].
    X = 1
    Y = 2
    Z = 3
    T = 4
    yes
    | ?- [1,2,3,4]=[X|Y].
    X = 1
    Y = [2,3,4]
    yes
    | ?- member(X,[1,2,3]),member(Y,[4,5]).
    X = 1
    Y = 4 ?;
    X = 1
    Y = 5 ?;
    X = 2
    Y = 4 ?;
    X = 2
    Y = 5 ?;
    X = 3
    Y = 4 ?;
    X = 3
    Y = 5 ?
    yes
*/

domain_of_X([-2,-1,0,1,2]).
domain_of_Y([-2,-1,0,1,2,100,101,102]).

solve_the_equation(X,Y):-
    domain_of_X(Dx),domain_of_Y(Dy),
    member(X,Dx),member(Y,Dy),
    Z is X+Y, Z == 0.

/* Recursion */
factorial(0,1).
factorial(N,Result):-
    N > 0,
    N1 is N-1,
    factorial(N1,A),
    Result is A*N.

