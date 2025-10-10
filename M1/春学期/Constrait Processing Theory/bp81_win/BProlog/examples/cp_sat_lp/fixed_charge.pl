% by Ray Rong, Feb. 2012

go:-
	machines(Machine),
	NbMachine is Machine^length,
	
	resourceName(ResName),
	NbRes is ResName^length,
	
	products(Product),
	NbProd is Product^length,
	
	go(NbMachine, NbRes,NbProd).
	
go(NbMachine, NbRes, NbProd):-
	length(Rent, NbMachine),
	length(Produce, NbProd),
	
	%accessing the database
	resources(Use),
	profit(Profit),
	rentingCost(RCost),
	capacity(Cap),
	MaxCap is max(Cap),	%obtaining the max capacity
	
	%domains
	Rent::0..1,
	Produce:: 0..MaxCap,
	
	%constraints
	foreach(R in 1..NbRes,
		sum([Use[P,R]*Produce[P]: P in 1..NbProd]) $=< Cap[R]),
	
	foreach(P in 1..NbProd,
		Produce[P] $=< Rent[P] * MaxCap), %Rent[P] is actually Rent[M]

	%objective
	TotalCost $= sum([Profit[P]*Produce[P]: P in 1..NbProd])-sum([RCost[M]*Rent[M]: M in 1..NbMachine]),

        append(Rent,Produce,AllVars),	
        ip_solve([max(TotalCost)],AllVars),
	writeln(total_cost(TotalCost)),
	writeln(rent(Rent)),
	writeln(produce(Produce)).

%data
products([shirts, shorts, pants]). 
resourceName([labor, cloth]).
capacity([150, 160]).
rentingCost([200, 150, 100]).
%product data
profit([6,4,7]).
machines([shirtM, shortM, pantM]).
resources([]([](3,4),
	     [](2,3),
	     [](6,4))).
