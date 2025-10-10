main => top.

top =>
    bp_best_plan([0,0],Plan),
    writeln(Plan).

final([4,_]) => true.
final([_,4]) => true.

action([_V1,V2],S1,Action,Cost) ?=>
    Action = fill1,
    Cost=1,
    capacity(1,C),
    S1 = [C,V2].
action([V1,_V2],S1,Action,Cost) ?=>
    Action = fill2,
    Cost=1,
    capacity(2,C),
    S1 = [V1,C].
action([V1,V2],S1,Action,Cost),V1>0 ?=>
    Action = empty1,
    Cost=1,
    S1 = [0,V2].
action([V1,V2],S1,Action,Cost),V2>0 ?=>
    Action = empty2,
    Cost=1,
    S1 = [V1,0].
action([V1,V2],S1,Action,Cost),V2>0 ?=>
    Action = transfer_2_to_1,
    Cost=1,
    capcity(1,C1),
    Liquid is V1+V2,
    Excess is Liquid-C1,
    (Excess=<0->
	W1=Liquid,W2=0
    ;
        W1=C1,W2=Excess
    ),
    S1=[W1,W2].
action([V1,V2],S1,Action,Cost),V1>0 =>
    Action = transfer_1_to_2,
    Cost=1,
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
