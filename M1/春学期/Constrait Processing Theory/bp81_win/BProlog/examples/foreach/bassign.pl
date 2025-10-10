/*
I would like to solve a simple problem in CLP: assign 26 groups of
people of various sizes to 6 slots respecting the capacity of each
slot and minimizing the conflicts among the preferences of people.
Preferences are expressed, for each group, as a list of distances from
optimum.
With the following ILOG OPL program, it takes just few seconds:

int T = ...;
int G = ...;

int InPref[1..T][1..G] = ...;
int InCapac[1..T] = ...;
int InGroups[1..G] = ...;

dvar int Slots[1..T][1..G] in 0..1;

minimize
   sum(t in 1..T)
      sum(g in 1..G)
         InPref[t][g] * Slots[t][g];

subject to {
   forall(t in 1..T)
      sum(g in 1..G) InGroups[g] * Slots[t][g] <= InCapac[t];

   forall(g in 1..G)
      sum(t in 1..T) Slots[t][g] == 1;

}
*/
/*
data(3, 2, Prefs, Capac, Compon) :-
        Prefs = [[0, 1, 1], [1, 0, 0]], % slot 1 is the first choice for group 1, a second choice for groups 2 and 3
        Capac = [8, 6], % the first slot can receive 8 people, the second 6
        Compon = [5, 3, 4]. % the first group has 5 people, the second 3, the third 4
*/
data(Groups, Slots, Prefs, Capac, Compon) :-
        Groups = 26,
        Slots = 6,
        Prefs = [
                 [1, 2, 6, 5, 6, 6, 3, 4, 4, 1, 2, 4, 4, 3, 1, 5, 1, 4, 5, 6, 5, 2,
5, 5, 3, 2],
                 [2, 3, 3, 2, 1, 4, 4, 2, 2, 6, 3, 1, 5, 5, 5, 6, 4, 2, 6, 4, 4, 5,
6, 2, 2, 1],
                 [5, 1, 1, 6, 3, 5, 5, 3, 6, 5, 5, 3, 6, 2, 4, 1, 6, 3, 2, 5, 1, 1,
2, 6, 4, 3],
                 [3, 6, 5, 3, 5, 3, 2, 1, 3, 3, 4, 2, 1, 1, 6, 2, 3, 5, 1, 3, 6, 3,
4, 3, 6, 5],
                 [4, 4, 4, 4, 2, 2, 1, 6, 1, 4, 6, 5, 2, 4, 2, 3, 5, 6, 4, 2, 3, 6,
1, 1, 1, 6],
                 [6, 5, 2, 1, 4, 1, 6, 5, 5, 2, 1, 6, 3, 6, 3, 4, 2, 1, 3, 1, 2, 4,
3, 4, 5, 4]
                ],
        Capac = [18, 18, 18, 18, 18, 18],
        Compon = [5, 4, 4, 4, 3, 3, 3, 3, 3, 4, 4, 5, 5, 2, 5, 3, 4, 4, 3, 3,
3, 5, 2, 4, 4, 5]. 
go:-
    data(NGroups, NSlots, Prefs, Capac, Compon),
    new_array(SG,[NSlots,NGroups]),
    Vars @= [SG[I,J] : I in 1..NSlots, J in 1..NGroups],
    Vars :: 0..1,
       % each group is assigned to one slot
    foreach(J in 1..NGroups, sum([SG[I,J] : I in 1..NSlots]) #= 1),
       % the capacity of each slot cannot be exceeded
    foreach(I in 1..NSlots, 
	    sum([SG[I,J]*Compon[J] : J in 1..NGroups]) #=< Capac[I]),
       % compute cost from preferences
    Cost #= sum([SG[I,J]*Prefs[I,J] : I in 1..NSlots, J in 1..NGroups]),
    minof(labeling(Vars),Cost,writeln(Cost)),
    foreach(J in 1..NGroups,
	    foreach(I in 1..NSlots, (SG[I,J]=:=1->writeln((J,I));true))),
    writeln(cost(Cost)).	    
