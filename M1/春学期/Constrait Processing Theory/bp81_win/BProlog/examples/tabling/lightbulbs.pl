/* The leftmost switch (i = 1) toggles the states of the
two leftmost bulbs (1 and 2); the rightmost switch (i = n)
toggles the states of the two rightmost bulbs (n - 1 and
n). Each remaining switch (1 < i < n) toggles the states of
the three bulbs with indices i - 1, i, and i + 1. The
minimum cost of changing a row of bulbs from an initial
configuration to a final configuration is the minimum
number of switches that must be flipped to achieve the
change. For instance, 01100 represents a row of five bulbs
in which the second and third bulbs are both ON. You could
transform this state into 10000 by flipping switches 1, 4,
and 5, but it would be less costly to simply flip switch 2. 

by Neng-Fa Zhou, updated 9/21/2013
*/
main =>
    test.

test =>
    S0=[0,1,1,0,0], 
    plan(S0,Plan,_Len),
    writeln(Plan).

final([1,0,0,0,0]) => true.

:-table plan(+,-,min).
plan(S,Plan,Len) ?=> final(S),!,Plan=[],Len=0.    
plan(S,Plan,Len) => 
    Plan=[Action|Plan1],
    action(S,S1,Action,ActionCost),
    plan(S1,Plan1,Len1),
    Len is Len1+ActionCost.

action([X1,X2|S],S1,Action,ActionCost) ?=> % the first switch
    Action=1,
    ActionCost=1,
    opposite(X1,OX1),
    opposite(X2,OX2),
    S1=[OX1,OX2|S].
action(S,S1,Action,ActionCost) ?=>
    ActionCost=1,
    select_action(S,S1,Action,2).

select_action([X1,X2],S1,Action,Switch) =>  % the last switch
    Action=Switch,
    opposite(X1,OX1),
    opposite(X2,OX2),
    S1=[OX1,OX2].
select_action([X1,X2,X3|S],S1,Action,Switch) ?=>
    Action=Switch,
    opposite(X1,OX1),
    opposite(X2,OX2),
    opposite(X3,OX3),
    S1=[OX1,OX2,OX3|S].
select_action([_X1,X2,X3|S],S1,Action,Switch) =>
    Switch1 is Switch+1,
    select_action([X2,X3|S],S1,Action,Switch1).

opposite(0,Opp) => Opp=1.
opposite(1,Opp) => Opp=0.





