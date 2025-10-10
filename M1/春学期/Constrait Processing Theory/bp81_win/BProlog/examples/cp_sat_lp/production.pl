% by Ray Rong, March 2012

go:-
	%access the data
	capacity(Cap),
	demand(Demand),
	insideCost(InCost),
	outsideCost(OutCost),
	consumption(Use),
	
	NProd is Use^length,
	NRes is Use[1]^length,
	length(Inside, NProd),
	length(Outside, NProd),
	
	%domain of Inside and outside are 0 to infinite
	
	%constraints
	foreach(R in 1..NRes,
		sum([Use[P,R]*Inside[P]: P in 1..NProd]) $=< Cap[R]),	%ct capacity

	foreach(P in 1..NProd,
		Inside[P]+Outside[P] $>= Demand[P]),	%ct demand
		
	%objective
	ProdCost $= sum([(InCost[P]*Inside[P]+OutCost[P]*Outside[P]):P in 1..NProd]),
				
	append(Inside, Outside, Vars),
	lp_solve(Vars, min(ProdCost)),
	writeln(production_cost(ProdCost)),
	writeln(inside_production(Inside)),
	writeln(outside_production(Outside)).
					
%products([kluski, capellini,fettucine]).
%resources([flour, eggs]).
%machinese([m1,m2,m3]).
capacity([20,40]).
demand([100,200,300]).
insideCost([0.6,0.8,0.3]). 		%cost: produce by own company
outsideCost([0.8,0.9,0.4]).		%cost: produce by outside company
consumption([]([](0.5, 0.2),	%resources consumption for products
			   [](0.4, 0.4),
			   [](0.3, 0.6))).



