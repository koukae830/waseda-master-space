go:-
    Vars=[X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20],
    Vars :: 1..9,
    word([X1,X2],3),
    word([X3,X4],6),
    word([X5,X6,X7,X8,X9],18),
    word([X10,X11,X12],23),
    word([X13,X14],9),
    word([X15,X16],6),
    word([X17,X18],15),
    word([X19,X20],12),
    
    word([X1,X5],4),
    word([X13,X17],17),
    word([X2,X6,X10,X14,X18],22),
    word([X7,X11],16),
    word([X3,X8,X12,X15,X19],16),
    word([X4,X9],3),
    word([X16,X20],14),
    
    labeling(Vars),
    write(Vars),nl,
    fail.

word(L,Sum):-
    all_different(L),
    sum(L) #= Sum.


    
