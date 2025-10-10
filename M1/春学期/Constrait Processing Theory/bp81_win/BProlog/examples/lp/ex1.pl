go:-
        Vars=[X1,X2,X3],
        lp_domain(X1,0,40),
        -X1+X2+X3 $=< 20,
        X1-3*X2+X3 $=< 30,
        Cost=X1+2*X2+3*X3,
        lp_solve(Vars,max(Cost)),
        format("sol(~w,~f)~n",[Vars,Cost]).
    
