/* In a farmyard, there are only chikens and rabbits. Its is known that there 
   are 18 heads and 58 feet. How many chikens and rabbits are there? */

go:-
	[X,Y] :: 1..58,
	X+Y #= 18,
	2*X+4*Y #= 58,
	labeling([X,Y]),
	writeln([X,Y]).
