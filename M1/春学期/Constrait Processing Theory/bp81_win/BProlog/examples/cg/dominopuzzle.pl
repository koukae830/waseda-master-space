/*
Title: Dominoes
Solved by: Neng-Fa Zhou
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

/* We use an array of domain variables

    V11,V12,...,V18,
    ...
    V71,V72,...,V78

    to indicate what two elements form a domino. Each variable takes a value from [left,right,up,down] which indicate the position of its parterner.

    For each two neighboring variables in a row V1 and V2, if V1 is "right" and V2 is "left" then a domino V1 and V2 
    form a domino. Similarly, for each two neighboring variables in a column V1 and V2, if V1 is "down" and V2 is "up",
    then V1 and V2 form a domino.

    We also use an array of boolean variables 

    B11,B12,...,B17
    ... 
    B71,B72,...,B77

    to ensure that no dominos can dupplicate.

*/
go:-top.

data(Board):-
    Board = [[3,1,2,6,6,1,2,2],
	      [3,4,1,5,3,0,3,6],
	      [5,6,6,1,2,4,5,0],
	      [5,6,4,1,3,3,0,0],
	      [6,1,0,6,3,2,4,0],
	      [4,1,5,2,4,3,5,5],
	      [4,1,0,2,4,5,2,0]].

top :-
    M=7,N=8,
    data(Board),
    new_array(Vs,[M,N]), 
    array_to_list(Vs,VsList),
    new_array(Bs,[N,N]),
    %
    constrainRows(Vs,Bs,Board,1,M,N), % if V1 pairs with V2, then V2 pairs with V1 as well
    constrainCols(Vs,Bs,Board,1,N,M),
    %
    VsList in [left,right,up,down],
    labeling(VsList),
    output(Board,Vs,M,N).

list_member([],D).
list_member([V|Vs],D):-member(V,D),
    list_member(Vs,D).

constrainRows(Vs,Bs,Board,I,M,N):-I>M,!.
constrainRows(Vs,Bs,Board,I,M,N):-
    (I=:=1 -> noUp(Vs,I,1,N);true),
    (I=:=M -> noDown(Vs,I,1,N);true),
    constrainRow(Vs,Bs,Board,I,1,N),
    I1 is I+1,
    constrainRows(Vs,Bs,Board,I1,M,N).

constrainRow(Vs,Bs,Board,I,J,N):-
    J=:=N,!.
constrainRow(Vs,Bs,Board,I,J,N):-
    J1 is J+1,
    Vs^[I,J] @= V1,
    Vs^[I,J1] @= V2,
    V1 #= right #=> V2 #= left,
    V2 #= left #=> V1 #= right,
    freeze(V1,freeze(V2,((V1 == right,V2 == left)->dominoFound(Bs,Board,I,J,I,J1);true))),
    constrainRow(Vs,Bs,Board,I,J1,N).

constrainCols(Vs,Bs,Board,J,N,M):-J>N,!.
constrainCols(Vs,Bs,Board,J,N,M):-
    (J=:=1 -> noLeft(Vs,1,M,J);true),
    (J=:=N -> noRight(Vs,1,M,J);true),
    constrainCol(Vs,Bs,Board,1,M,J),
    J1 is J+1,
    constrainCols(Vs,Bs,Board,J1,N,M).

constrainCol(Vs,Bs,Board,I,M,J):-
    I=:=M,!.
constrainCol(Vs,Bs,Board,I,M,J):-
    I1 is I+1,
    Vs^[I,J] @= V1, 
    Vs^[I1,J] @= V2,
    V1 #= down #=> V2 #= up,
    V2 #= up #=> V1 #= down,
    freeze(V1,freeze(V2,((V1 == down,V2 == up)->dominoFound(Bs,Board,I,J,I1,J);true))),
    constrainCol(Vs,Bs,Board,I1,M,J).

dominoFound(Bs,Board,I1,J1,I2,J2):-
     Board^[I1,J1] @= D1, 
     Board^[I2,J2] @= D2, 
     (D1<D2->I is D1+1,J is D2+1;
      I is D2+1,J is D1+1),
     Bs^[I,J] @= V,
     var(V),V=1.
     
noUp(Vs,I,J,N):-J>N,!.
noUp(Vs,I,J,N):-
   Vs^[I,J] #\= up,
   J1 is J+1,
   noUp(Vs,I,J1,N).

noDown(Vs,I,J,N):-J>N,!.
noDown(Vs,I,J,N):-
   Vs^[I,J] #\= down,
   J1 is J+1,
   noDown(Vs,I,J1,N).

noLeft(Vs,I,M,J):-I>M,!.
noLeft(Vs,I,M,J):-
   Vs^[I,J] #\= left,
   I1 is I+1,
   noLeft(Vs,I1,M,J).

noRight(Vs,I,M,J):-I>M,!.
noRight(Vs,I,M,J):-
   Vs^[I,J] #\= right,
   I1 is I+1,
   noRight(Vs,I1,M,J).
    
output(Data,Orient,M,N):-
    new_array(Board,[M,N]),
    Board^[1,1] @= Lab0,
    array_to_list(Board,Comps),
    cgString(Comps),
    Lab0^width #= 30,
    cgGrid(Board),
    createDominos(Data,Board,Orient,1,M,N,Dominos),
    cgWindow(Win,"Domino puzzle"),
    Win^leftMargin #= 100, Win^topMargin #= 100,
    cgSame(Comps,window,Win),
    cgSame(Dominos,window,Win),
    cgShow(Comps),
    cgShow(Dominos).

createDominos(Data,Board,Orient,I,M,N,Dominos):-I>M,!,Dominos=[].
createDominos(Data,Board,Orient,I,M,N,Dominos):-
    createDominos(Data,Board,Orient,I,1,M,N,Dominos,Dominos1),
    I1 is I+1,
    createDominos(Data,Board,Orient,I1,M,N,Dominos1).

createDominos(Data,Board,Orient,I,J,M,N,Dominos,DominosR):-J>N,!,Dominos=DominosR.
createDominos(Data,Board,Orient,I,J,M,N,Dominos,DominosR):-
    Data^[I,J] @= Num,
    number_codes(Num,Str),
    Board^[I,J] @= Lab,
    cgSetText(Lab,Str),
    Lab^fontSize #= 18,
    cgSetAlignment(Lab,center),
    cgRectangle(Domino),Domino^fill #= 0,
    Dominos=[Domino|Dominos1],
    (Orient^[I,J]@=left->
     Domino^x #= Lab^x-Lab^width,
     Domino^y #= Lab^y,
     Domino^width #= Lab^width*2,
     Domino^height #= Lab^height;

     Orient^[I,J]@=right->
     Domino^x #= Lab^x,
     Domino^y #= Lab^y,
     Domino^width #= Lab^width*2,
     Domino^height #= Lab^height;

     Orient^[I,J]@=up->
     Domino^x #= Lab^x,
     Domino^y #= Lab^y-Lab^height,
     Domino^width #= Lab^width,
     Domino^height #= Lab^height*2;

     % down
     Domino^x #= Lab^x,
     Domino^y #= Lab^y,
     Domino^width #= Lab^width,
     Domino^height #= Lab^height*2),
    J1 is J+1,
    createDominos(Data,Board,Orient,I,J1,M,N,Dominos1,DominosR).

    
