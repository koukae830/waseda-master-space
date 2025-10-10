% by Ray Rong, March 2012

go:-
	maxProduction(MaxProd),
	prodCost(ProdCost),
	go(MaxProd, ProdCost).
	
go(MaxProd, ProdCost):-
	gas(Gas),
	NGas is Gas^length,	
	oil(Oil),
	NOil is Oil^length,
	
	length(Adv, NGas), 	%advertising the gasoline 
	new_array(Blend, [NOil, NGas]),
	term_variables(Blend, Vars),
	
        foreach(Var in Vars, Var $>= 0),
	%domain is 0 to infinite.  Don't need to specify for lp
	
	%constraint
	foreach(G in 1..NGas,
		sum([Blend[O,G]:O in 1..NOil]) $= Gas[G,1] + 10*Adv[G]),  	%demain constraint
	
	foreach(O in 1..NOil,
		sum([Blend[O,G]:G in 1..NGas]) $=< Oil[O,1]), 				%ct capacity
	
	sum([Blend[O,G]:O in 1..NOil, G in 1..NGas]) $=< MaxProd, 		%ct max production
	
	foreach(G in 1..NGas,
		sum([Oil[O,3]*Blend[O,G]: O in 1..NOil])
			- sum([Gas[G,3]*Blend[O,G]: O in 1..NOil]) $>= 0),		%ct octane
	foreach(G in 1..NGas,	
		sum([Oil[O,4]*Blend[O,G]: O in 1..NOil])
			-sum([Gas[G,4]*Blend[O,G]: O in 1..NOil]) $=< 0),		%ct lead
			
	%objective
	BlendTotal $= sum([Gas[G,2]*Blend[O,G]: O in 1..NOil, G in 1..NGas])
					-sum([Oil[O,2]*Blend[O,G]: O in 1..NOil, G in 1..NGas])
					-sum([ProdCost * Blend[O,G]: O in 1..NOil, G in 1..NGas])
					-sum([Adv[G]: G in 1..NGas]),
	
	append(Adv, Vars, AllVars),
	lp_solve([max(BlendTotal)],AllVars),
	writeln(blend_total(BlendTotal)),
	writeln(blend(Blend)),
	writeln(advertise(Adv)).

%gasolines([super, regular, diesel]).
%oils([crudel, crudel2, crude3]).

maxProduction(14000).
prodCost(4).
gas([]([](3000, 70, 10, 1), 	%(demand, price, octane, lead)
	   [](2000, 60, 8, 2),
	   [](1000, 50, 6, 1))).
	   
oil([]([](5000, 45, 12, 0.5),	%(capacity, price, octane, lead)
	   [](5000, 35, 6,  2),
	   [](5000, 25, 8,  3))).

	   
