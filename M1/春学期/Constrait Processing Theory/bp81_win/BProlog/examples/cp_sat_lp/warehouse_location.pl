% by Ray Rong, Feb. 2012

go:-
	go(30).

go(Fixed):-
	capacity(Cap),
	NbWareHouses is Cap^length,	
	supplyCost(SCost),
	NbStores is SCost^length,
	
	length(Open, NbWareHouses),	%create warehouse openning list
	new_array(Supply, [NbStores, NbWareHouses]), 	%create supply array
	
	%domains
	Open :: 0..1,
	term_variables(Supply, Vars),	
        Vars :: 0..1,

	%constraints
	foreach(S in 1..NbStores,
			sum([Supply[S,W] : W in 1..NbWareHouses]) $= 1),
	
	foreach(S in 1..NbStores, W in 1..NbWareHouses,
			Supply[S,W] $=< Open[W]),
	
	foreach(W in 1..NbWareHouses,
			sum([Supply[S,W]: S in 1..NbStores]) $=< Cap[W]),
			
	%objective
	TotalSupplyCost $= sum([Fixed*Open[W]:W in 1..NbWareHouses])
						+ sum([SCost[S,W]*Supply[S,W]:S in 1..NbStores, W in 1..NbWareHouses]),
        append(Open,Vars,AllVars),
        ip_solve([min(TotalSupplyCost)],AllVars),
	writeln(Open),
	writeln(Vars).


warehouses([bonn,bordeaux,london,paris,rome]).
capacity([1,4,2,1,3]).
supplyCost([]([]( 20, 24, 11, 25, 30 ),
			  []( 28, 27, 82, 83, 74 ),
			  []( 74, 97, 71, 96, 70 ),
			  [](  2, 55, 73, 69, 61 ),
			  []( 46, 96, 59, 83,  4 ),
			  []( 42, 22, 29, 67, 59 ),
			  [](  1,  5, 73, 59, 56 ),
	     	  []( 10, 73, 13, 43, 96 ),
			  []( 93, 35, 63, 85, 46 ),
			  []( 47, 65, 55, 71, 95 ))).
			  
