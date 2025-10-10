go:-
    statistics(runtime,[Start|_]),
    top,
    statistics(runtime,[End|_]),
    T is End-Start,
    write('execution time is '),write(T), write(milliseconds),nl.

top:-
    vars_constraints(Vars),
    labeling(Vars),
    write(Vars).

vars_constraints(Vars):-
    Vars=[X1,X2,X3,X4,X5,X6,X7,X8,X9],
    Vars in 1..9,
    alldifferent(Vars),
    X1+X2+X3#=15,
    X4+X5+X6#=15,
    X7+X8+X9#=15,
    X1+X4+X7#=15,
    X2+X5+X8#=15,
    X3+X6+X9#=15,
    X1+X5+X9#=15,
    X3+X5+X7#=15.


