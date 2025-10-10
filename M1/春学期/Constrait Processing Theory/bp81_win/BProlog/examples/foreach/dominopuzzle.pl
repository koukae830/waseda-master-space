/*
Title: Dominoes
Solved by: Neng-Fa Zhou (Dec. 2009, adapated using foreach and list comprehension)
Publication: Dell Logic Puzzles
Issue: Sep. 2001
Page: 19
Stars: 3

*/
/*
The dominoes of an ordinary double-six set have been scrambled and arranged into the pattern shown below. Each number shows the number of pips in that square, from zero to six, but the boundaries between the dominoes have all been removed. Can you deduce where each domino is, and draw in the lines to show how they are arranged? Each domino is used exactly once. 

There are 28 dominoes: 0-0, 0-1, 0-2, ... 5-5, 5-6, 6-6. 

Puzzle pattern:

3 1 2 6 6 1 2 2
3 4 1 5 3 0 3 6
5 6 6 1 2 4 5 0
5 6 4 1 3 3 0 0 
6 1 0 6 3 2 4 0
4 1 5 2 4 3 5 5
4 1 0 2 4 5 2 0 
*/

go:-
    data(Config),
    new_array(A,[7,8]),
    Vars @= [A[I,J] : I in 1..7, J in 1..8],
    D @= [X : I in 0..6, J in I..6,[X], X is I*10+J],  % D=[0,1,6,11,..,16,...,55,56,66]
    Vars :: D,

    Table1 @= [(E,Rem) : E in D, [Rem], Rem is E mod 10],
    Table2 @= [(E,Div) : E in D, [Div], Div is E // 10],
    append(Table1,Table2,Table),

    foreach(I in 1..7, J in 1..8, 
	    [Aij,Cij],
	    (Aij @= A[I,J],
	     Cij @= Config[I,J],
	     (Aij,Cij) in Table,
	     form_domino(A,I,J))),

    Values @= [X-2 : X in D],
    global_cardinality(Vars,Values),

    labeling([ff],Vars),
    foreach(I in 1..7, 
	    (foreach(J in 1..8,[Aij],(Aij @=A[I,J],format("~2d ",[Aij]))),nl)).
    

% Exactly one of A[I,J]'s neighbors is the same as A[I,J]
form_domino(A,I,J):-
     sum([(A[I1,J1]#=A[I,J]) : 
          I1 in I-1..I+1, J1 in J-1..J+1, 
          (I1>0,I1=<7,J1>0,J1=<8,(I1=I;J1=J),(I,J)\=(I1,J1))]) #= 1.

data(Board):-
    Board = [[3,1,2,6,6,1,2,2],
	      [3,4,1,5,3,0,3,6],
	      [5,6,6,1,2,4,5,0],
	      [5,6,4,1,3,3,0,0],
	      [6,1,0,6,3,2,4,0],
	      [4,1,5,2,4,3,5,5],
	      [4,1,0,2,4,5,2,0]].


    
