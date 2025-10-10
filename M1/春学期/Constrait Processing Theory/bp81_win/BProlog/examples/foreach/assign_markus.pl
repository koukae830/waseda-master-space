solve(Slots, Cost) :-
    data(NGroups, NSlots, Prefs, Capacities, Members),
    length(Groups, NGroups),
    Groups :: 1..NSlots,

    Vs @= [I : I in 1..NSlots],  % Vs=[1,2,...,NSlots]

    % if Slot is assigned to a group of N members,

    group is assigned to Slot, Group
    Values @= [Slot-N : (Slot,C) in (Vs,Capacities), 
	                 [Slot,C],   % local vars
	                 slots(Groups,Members,Slot,C,Slot-N)],
    foreach(Slot-N in Values, cardinality(Groups,Slot,N)),

    Cost #= sum([(Groups[G]#=T)*Prefs[T,G] : T in 1..NSlots, G in 1..NGroups]),

           transpose(Prefs, Matrix),
           maplist(preferences(Vs), Groups, Matrix, Costs),
           sum(Costs, #=, Cost),
           maplist(cardinality(Groups), Values).

   cardinality(Vs, Key-Val) :-
           maplist(eq_b(Key), Vs, Bs),
           sum(Bs, #=, Val).

   preferences(Vs, Slot, Row, Cost) :-
           element(N, Vs, Slot),
           element(N, Row, Cost).

   slots(Groups, Members, Slot, C, Slot-N) :-
           maplist(eq_b(Slot), Groups, Bs),
           sum(Bs, #=, N),
           scalar_product(Members, Bs, #=<, C).

   eq_b(X, Y, B) :- X #= Y #<==> B. 
