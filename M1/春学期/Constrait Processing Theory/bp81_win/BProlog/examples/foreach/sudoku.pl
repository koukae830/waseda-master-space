%   File   : sudoku.pl (in B-Prolog)
%   Author : Neng-Fa ZHOU
%   Date   : 2009 (using foreach and list comprehension)
%   Purpose: solve the sudoku puzzle

go:-
    instance(N,A),
    Vars @= [A[I,J] : I in 1..N, J in 1..N],
    Vars :: 1..N,
    foreach(I in 1..N, [Row], 
	    (Row @= [A[I,J] : J in 1..N], all_distinct(Row))),
    foreach(J in 1..N, [Col], 
	    (Col @= [A[I,J] : I in 1..N], all_distinct(Col))),
    M is floor(sqrt(N)),
    foreach(I in 1..M, J in 1..M, 
	    [Square],
	    (Square @= [A[I1,J1] : I1 in (I-1)*M+1..I*M, J1 in (J-1)*M+1..J*M],
	     all_distinct(Square))),
    labeling([ff],Vars),
    foreach(I in 1..N,
	    (foreach(J in 1..N,[Aij], (Aij @= A[I,J], format("~2d ",[Aij]))),nl)).
    
instance(9,A):-
    new_array(A,[9,9]),
    A[1,2]#=6, A[1,4]#=2, A[1,6]#=4, A[1,8]#=5,
    A[2,1]#=4, A[2,2]#=7, A[2,5]#=6, A[2,8]#=8, A[2,9]#=3,
    A[3,3]#=5, A[3,5]#=7, A[3,7]#=1,
    A[4,1]#=9, A[4,4]#=1, A[4,6]#=3, A[4,9]#=2,
    A[5,2]#=1, A[5,3]#=2, A[5,9]#=9,
    A[6,1]#=6, A[6,4]#=7, 
    A[7,3]#=6, A[7,5]#=8, A[7,7]#=7,
    A[8,1]#=1, A[8,2]#=4, A[8,5]#=9, A[8,8]#=2, A[8,9]#=5,
    A[9,2]#=8, A[9,4]#=3, A[9,6]#=5, A[9,8]#=9.
