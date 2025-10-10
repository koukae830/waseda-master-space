main => top.

top =>
    plan([0,0],Plan,_),
    writeln(Plan).

:-table plan(+,-,min).
plan(State,Plan,Len) ?=> final(State),!,Plan=[], Len=0.
plan(State,Plan,Len) =>
    Plan=[Action|Plan1],
    action(State,State1,Action),
    plan(State1,Plan1,Len1),
    Len is Len1+1.

final([4,_]) => true.
final([_,4]) => true.

action([_V1,V2],S1,Action) ?=>
    Action = fill1,
    capacity(1,C),
    S1 = [C,V2].
action([V1,_V2],S1,Action) ?=>
    Action = fill2,
    capacity(2,C),
    S1 = [V1,C].
action([V1,V2],S1,Action),V1>0 ?=>
    Action = empty1,
    S1 = [0,V2].
action([V1,V2],S1,Action),V2>0 ?=>
    Action = empty2,
    S1 = [V1,0].
action([V1,V2],S1,Action),V2>0 ?=>
    Action = transfer_2_to_1,
    capcity(1,C1),
    Liquid is V1+V2,
    Excess is Liquid-C1,
    (Excess=<0->
	W1=Liquid,W2=0
    ;
        W1=C1,W2=Excess
    ),
    S1=[W1,W2].
action([V1,V2],S1,Action),V1>0 =>
    Action = transfer_1_to_2,
    capcity(2,C2),
    Liquid is V1+V2,
    Excess is Liquid-C2,
    (Excess=<0->
	W2=Liquid,W1=0
    ;
        W2=C2,W1=Excess
    ),
    S1=[W1,W2].    

capacity(1,C1) => C1=8.
capcity(2,C2) => C2=5.
