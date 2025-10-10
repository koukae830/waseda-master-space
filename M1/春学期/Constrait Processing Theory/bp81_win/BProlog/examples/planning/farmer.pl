main => top.

top =>
    S0=[s,s,s,s],
    bp_best_plan(S0,Plan),
    writeln(Plan).

final([n,n,n,n]) => true.

action([F,F,G,C],S1,Action,Cost) ?=>
    Action=farmer_wolf,
    Cost=1,
    opposite(F,F1),
    S1=[F1,F1,G,C],
    not unsafe(S1).
action([F,W,F,C],S1,Action,Cost) ?=>
    Action=farmer_goat,
    Cost=1,
    opposite(F,F1),
    S1=[F1,W,F1,C],
    not unsafe(S1).
action([F,W,G,F],S1,Action,Cost) ?=>
    Action=farmer_cabbage,
    Cost=1,
    opposite(F,F1),
    S1=[F1,W,G,F1],
    not unsafe(S1).
action([F,W,G,C],S1,Action,Cost) ?=>
    Action=farmer_alone,
    Cost=1,
    opposite(F,F1),
    S1=[F1,W,G,C],
    not unsafe(S1).

opposite(n,Opp) => Opp=s.
opposite(s,Opp) => Opp=n.

unsafe([F,W,G,_C]),W==G,F\==W => true.
unsafe([F,_W,G,C]),G==C,F\==G => true.
