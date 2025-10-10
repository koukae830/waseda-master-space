%dual of ex3.pl

go:-
    Vars=[Y1,Y2,Y3],
    0.25*Y1 + 1.25*Y2 + 1.0*Y3 $>= 15,
    1.0*Y1 + 0.5*Y2 + 1.0*Y3 $>= 10,
    Cost= 65*Y1 + 90*Y2 + 85*Y3,
    lp_solve(Vars,min(Cost)),
    format("sol(~w,~f)~n",[Vars,Cost]).
