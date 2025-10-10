/*-------------------------------------------------------------------------*/
/* Adapted to B-Prolog using foreach by Neng-Fa Zhou
/*                                                                         */
/* Put N pigeons in M pigeon-holes. Solution iff N<=M.                     */
/* The solution is a list [ [Pig11,...,Pig1m], ... ,[Pign1,...,Pignm] ]    */
/* where Pigij = 1 if the pigeon i is in the pigeon-hole j                 */
/*                                                                         */
/* Solution:                                                               */
/* N=2 M=3 [[0,0,1],[0,1,0]]                                               */
/*         [[0,0,1],[1,0,0]]                                               */
/*         [[0,1,0],[0,0,1]]                                               */
/*         [[0,1,0],[1,0,0]]                                               */
/*         [[1,0,0],[0,0,1]]                                               */
/*         [[1,0,0],[0,1,0]]                                               */
/*-------------------------------------------------------------------------*/

go:-	
    statistics(runtime,_),
    top,
    statistics(runtime,[_,Y]),
    write('time : '), write(Y), nl.

top:-
    N=4,
    M=5,
    new_array(A,[N,M]),
    foreach(I in 1..N, sum([A[I,J] : J in 1..M])#=1),
    foreach(J in 1..M, sum([A[I,J] : I in 1..N])#=<1),
    L @= [A[I,J] : I in 1..N, J in 1..M],
    L :: 0..1,
    labeling(L),
    foreach(I in 1..N,[Row],(Row @= A[I], writeln(Row))),
    nl,nl,	    
    fail.
top.


