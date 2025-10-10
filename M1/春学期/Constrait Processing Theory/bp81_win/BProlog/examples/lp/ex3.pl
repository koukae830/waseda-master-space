go:-
    Vars=[X1,X2],
    0.25*X1 + 1.0*X2 $=< 65,
    1.25*X1 + 0.5*X2 $=< 90,
    1.0*X1 + 1.0*X2 $=< 85,
    Cost= 15*X1 + 10*X2,
    lp_solve(Vars,max(Cost)),
    format("sol(~w,~f)~n",[Vars,Cost]).
