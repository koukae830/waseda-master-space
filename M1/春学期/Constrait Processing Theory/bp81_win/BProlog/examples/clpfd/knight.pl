/* 
    Find a knight tour that connects all the squares 
    by Neng-Fa Zhou, 2001, modified in 2005
*/

go:-
    solve(Vars),
    output(Vars).

solve(Vars):-
    length(Vars,64), % 8*8=64
    computeDomain(Vars,1),
    circuit(Vars),  % built-in
    labeling_ff(Vars).

computeDomain([],N).
computeDomain([V|Vs],N):-
    I is (N-1)//8,
    J is (N-1) mod 8,
    feasiblePositions(I,J,D),
    V in D,
    N1 is N+1,
    computeDomain(Vs,N1).

feasiblePositions(I,J,D):-
    I1 is I+1,  J1 is J+2,
    I2 is I+1,  J2 is J-2,
    I3 is I-1,  J3 is J+2,
    I4 is I-1,  J4 is J-2,
    I5 is I+2,  J5 is J+1,
    I6 is I+2,  J6 is J-1,
    I7 is I-2,  J7 is J+1,
    I8 is I-2,  J8 is J-1,
    addFeasiblePositions([(I1,J1),(I2,J2),(I3,J3),(I4,J4),(I5,J5),(I6,J6),(I7,J7),(I8,J8)],D).
    
addFeasiblePositions([],D):-D=[].
addFeasiblePositions([(I,J)|IJs],D):-
    (I>=0,I<8,J>=0,J<8),!,
    N is I*8+J+1,
    D=[N|D1],
    addFeasiblePositions(IJs,D1).
addFeasiblePositions([_|IJs],D):-
    addFeasiblePositions(IJs,D).

output(Vars):-
    Array=..[a|Vars],
    output(Array,0,0,1).

output(Array,I,J,N):-N>64,!.
output(Array,I,J,N):-
    P is I*8+J+1,
    arg(P,Array,P1),
    I1 is (P1-1)//8,
    J1 is (P1-1) mod 8,
    write((I,J)),write(' => '),write((I1,J1)),nl,
    N1 is N+1,
    output(Array,I1,J1,N1).
