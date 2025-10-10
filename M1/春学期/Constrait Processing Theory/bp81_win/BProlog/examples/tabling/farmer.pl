main => top.

top =>
    S0=[s,s,s,s],
    plan(S0,Plan,_),
    writeln(Plan).

final([n,n,n,n]) => true.

:-table plan(+,-,min).
plan([n,n,n,n],Plan,Len) => Plan=[], Len=0.
plan(S,Plan,Len) =>
    Plan=[Action|Plan1],
    action(S,S1,Action),
    plan(S1,Plan1,Len1),
    Len is Len1+1.

action([F,F,G,C],S1,Action) ?=>
    Action=farmer_wolf,
    opposite(F,F1),
    S1=[F1,F1,G,C],
    not unsafe(S1).
action([F,W,F,C],S1,Action) ?=>
    Action=farmer_goat,
    opposite(F,F1),
    S1=[F1,W,F1,C],
    not unsafe(S1).
action([F,W,G,F],S1,Action) ?=>
    Action=farmer_cabbage,
    opposite(F,F1),
    S1=[F1,W,G,F1],
    not unsafe(S1).
action([F,W,G,C],S1,Action) ?=>
    Action=farmer_alone,
    opposite(F,F1),
    S1=[F1,W,G,C],
    not unsafe(S1).

opposite(n,Opp) => Opp=s.
opposite(s,Opp) => Opp=n.

unsafe([F,W,G,_C]),W==G,F\==W => true.
unsafe([F,_W,G,C]),G==C,F\==G => true.
