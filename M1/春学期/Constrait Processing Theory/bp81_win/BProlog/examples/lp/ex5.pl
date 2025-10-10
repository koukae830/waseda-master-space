go:-
    Vars=[X1,X2],
    X1 + X2 $=< 65,
    X1 + X2 $>= 90,
    Cost= 15*X1 + 10*X2,
    lp_solve(Vars,max(Cost)),
    format("sol(~w,~f)~n",[Vars,Cost]).
