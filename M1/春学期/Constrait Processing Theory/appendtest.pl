append2([A|B],C,X):-
	append(B,C,Y),
	X = [A|Y].
