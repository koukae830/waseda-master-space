go:-
    [W,P,C] :: 0..9,
    4*W+3*P+2*C #=< 9,
    maxof(labeling([W,P,C]),15*W+10*P+7*C),
    Profit is 15*W+10*P+7*C,
    writeln([W,P,C]),
    writeln(profit(Profit)).
