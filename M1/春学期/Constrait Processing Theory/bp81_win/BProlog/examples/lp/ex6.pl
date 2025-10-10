go:-
        Vars=[X1,X2,X3],
        X1+X2+X3 $=< 100,
        10*X1+4*X2+5*X3 $=< 600,
        2*X1+2*X2+6*X3 $=< 300,
        Cost=10*X1+6*X2+4*X3,
        lp_solve(Vars,max(Cost)),
        format("sol(~w,~f)~n",[Vars,Cost]).
