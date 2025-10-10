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

    % use a variable for each group which takes on a slot
    length(Groups,NGroups),  
    Groups :: 1..NSlots,

    % the capacity cannot be exceeded
    foreach(T in 1..NSlots, 
	    sum([(Groups[G]#=T)*Compon[G] : G in 1..NGroups]) #=< Capac[T]),

    % get cost from preferences
    Cost #= sum([(Groups[G]#=T)*Prefs[T,G] : T in 1..NSlots, G in 1..NGroups]),
        
    % OPrefs=[OPref1,OPref2,...] where each OPrefi is a sorted list 
    % [P1-T1,P2-T2,...], where Pi the preference for slot Ti
    length(OPrefs,NGroups),
    foreach(G in 1..NGroups,[Temp1,Temp2],  % Temp1 and Temp2 are local vars
         (Temp1 @= [P-T : T in 1..NSlots,[P],P is Prefs[T,G]],
          sort(Temp1,Temp2),
          OPrefs[G] @= Temp2)),

    minof(mylabeling(Groups,OPrefs),Cost,writeln((Groups,Cost))).

mylabeling([],_).
mylabeling([Group|Vars],[OPref|OPrefs]):-
    member(_-Group,OPref),
    mylabeling(Vars,OPrefs).

		  


