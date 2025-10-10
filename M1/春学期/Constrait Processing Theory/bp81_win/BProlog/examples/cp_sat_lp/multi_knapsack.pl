% by Ray Rong, Feb. 2012

go:-
	value(ValueArray),
	go(7, 12, ValueArray).

go(NbResources,NbItems,ValueArray):-
	length(Take, NbItems),
	capacity(Cap),			%unify C to capacity list
	Take :: 0..max(Cap), 	%obtaining the max value of the capacity

	%term_variables(Take, Vars),
	foreach(R in 1..NbResources,
		([UseList]),
		(use(R,UseList),
		sum([(UseList[I]*Take[I]): I in 1..NbItems]) $=< Cap[R])
	),
	TotalItems $= sum([ValueArray[I]*Take[I]: I in 1..NbItems]),
        ip_solve([max(TotalItems)],Take),
	writeln(Take), 
	writeln(value(TotalItems)).	
	
capacity([18209,7692,1333,924,26638,61188,13360]).
value([96,76,56,11,86, 10, 66, 86, 83, 12, 9,81]).
use(1,[19,1,10,1,1,14,152,11,1,1,1,1]).
use(2,[0,4,53,0,0,80,0,4,5,0,0,0]).
use(3,[4,660,3,0,30,0,3,0,4,90,0,0]).
use(4,[7,0,18,6,770,330,7,0,0,6,0,0]).
use(5,[0,20,0,4,52,3,0,0,0,5,4,0]).
use(6,[0,0,40,70,4,63,0,0,60,0,4,0]).
use(7,[0,32,0,0,0,5,0,3,0,660,0,9]).


