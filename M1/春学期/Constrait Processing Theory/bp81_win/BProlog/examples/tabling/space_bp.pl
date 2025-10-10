go:-
    p(P,S,T),
    RealS is S-220-4-16,
    Line=..[P,RealS,T],
    write(Line),write('.'),nl,
    fail.
go.

p(transitiveLeft,S,T):-
    S is 300+48+40,
    T is 44780.
p(transitiveRight,S,T):-
    S is 1080+48+144,
    T is 145676.
p(sg,S,T):-
    S is 1468+48+144,
    T is 69740.
p(cs_o,S,T):-
    S is 8492+12292+1240,
    T is 20308.
p(cs_r,S,T):-
    S is 14768+23396+2280,
    T is 20396.
p(disj,S,T):-
    S is 6472+9668+1160,
    T is 20104.
p(gabriel,S,T):-
    S is 10204+11104+1200,
    T is 16492.
p(kalah,S,T):-
    S is 14300+20016+2080,
    T is 26884.
p(peep,S,T):-
    S is 28028+54016+6496,
    T is 15260.
p(pg,S,T):-
    S is 17856+30532+3528,
    T is 13860.
p(read,S,T):-
    S is 26544+44604+4944,
    T is 38388.

