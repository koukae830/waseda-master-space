% http://www.cs.kuleuven.be/~dtai/events/ASP-competition/Benchmarks/MazeGeneration.shtml
% by Neng-Fa Zhou, April 12, 2009, updated Dec. 21, 2009

%:-include(base).   

solve(As):-
    member(row(N),As), not (member(row(N1),As), N1>N), % N is the largest
    member(col(M),As), not (member(col(M1),As), M1>M), % M is the largest
    new_array(Maze,[M,N]), % a 2-dimensional array
    (member(entrance(Xen,Yen),As)->true;true),
    Maze[Xen,Yen] @= node(Nen,0),
    (member(exit(Xex,Yex),As)->true;true),
    Maze[Xex,Yex] @= node(Nex,0),
    fill_wall_empty_cells(As,Maze),
    fill_edges(Maze,M,N),
    init_maze(Maze,M,N),
    constrain_2x2(Maze,M,N),
    not_surrounded(Maze,M,N),
    construct_graph(Maze,M,N,Nodes,Vars),
    number_nodes(Nodes,1),
    path_atleast_one(Nodes,0,Nen,Nex), % ensure there is always a path from entrace to exit
                                       % and all empty cells are connected
    labeling([ffc],Vars),!,
    output(Maze,M,N).
solve(_):-
    format("UNSATISFIABLE~n").

number_nodes([],_).
number_nodes([node(No,_,_)|Nodes],No):-
    No1 is No+1,
    number_nodes(Nodes,No1).

fill_wall_empty_cells([],_).
fill_wall_empty_cells([wall(X,Y)|As],Maze):-!,
    Maze[X,Y] @= node(_,1),
    fill_wall_empty_cells(As,Maze).
fill_wall_empty_cells([empty(X,Y)|As],Maze):-!,
    Maze[X,Y] @= node(_,0),
    fill_wall_empty_cells(As,Maze).
fill_wall_empty_cells([_|As],Maze):-
    fill_wall_empty_cells(As,Maze).

% If a cell is on any of the edges of the grid, and is not an 
% entrance or an exit, it must contain a wall. 
fill_edges(Maze,M,N):-
    foreach(X in 1..M,
	     [E1,E2,No1,No2],
	     (Maze[X,1] @= E1,(var(E1)->E1=node(No1,1);true),
	      Maze[X,N] @= E2,(var(E2)->E2=node(No2,1);true))),
    foreach(Y in 1..N,
	     [E1,E2,No1,No2],
	     (Maze[1,Y] @= E1,(var(E1)->E1=node(No1,1);true),
	      Maze[M,Y] @= E2,(var(E2)->E2=node(No2,1);true))).
    
init_maze(Maze,M,N):-
    foreach(X in 1..M, Y in 1..N,
             [Cxy,V,No],
             (Maze[X,Y] @= Cxy,
              Cxy=node(No,V),
              V :: 0..1)).
   
% There must be no 2x2 blocks of empty cells or walls. 
% If two walls are diagonally adjacent then one or other of 
% their common neighbours must be a wall. 
constrain_2x2(Maze,M,N):-
    foreach(X in 1..M-1, Y in 1..N-1,
            [A11,A12,A21,A22,No11,No12,No21,No22],
	    (Maze[X,Y] @= node(No11,A11),
	     Maze[X,Y+1] @= node(No12,A12),
	     Maze[X+1,Y] @= node(No21,A21),
	     Maze[X+1,Y+1] @= node(No22,A22),
	     A11+A12+A21+A22#>0,
	     A11+A12+A21+A22#<4,
	     A11+A22#=2 #=> A12+A21#=1,
	     A12+A21#=2 #=> A11+A22#=1)).

% No wall can be completely surrounded by empty cells.     
not_surrounded(Maze,M,N):-
    foreach(X in 3..M-2, Y in 3..N-2,
             [This,Left,Right,Up,Down,NoThis,NoLeft,NoRight,NoUp,NoDown],
            (Maze[X,Y] @= node(NoThis,This),
             Maze[X-1,Y] @= node(NoLeft,Left),
	      Maze[X+1,Y] @= node(NoRight,Right),
	      Maze[X,Y-1] @= node(NoUp,Up),
	      Maze[X,Y+1] @= node(NoDown,Down),
	     This #= 1 #=> Left+Right+Up+Down #> 0)).

construct_graph(Maze,M,N,Nodes,Vars):-
    foreach(X in 1..M, Y in 1..N,
	    [Cxy,Neibs,V,No],
	    (Maze[X,Y] @= Cxy,
            Cxy=node(No,V),
            (V==1->true;
              get_neighbors(Maze,M,N,X,Y,Neibs),
              attach(node(No,V,Neibs),Nodes),
              (var(V)->attach(V,Vars);true)))),
     closetail(Nodes),
     closetail(Vars).

get_neighbors(Maze,M,N,X,Y,Neibs):-
     X1 is X-1, X2 is X+1,
     Y1 is Y-1, Y2 is Y+1,
     get_neighbor(Maze,M,N,X1,Y,Neibs,Neibs1),
     get_neighbor(Maze,M,N,X,Y1,Neibs1,Neibs2),
     get_neighbor(Maze,M,N,X2,Y,Neibs2,Neibs3),
     get_neighbor(Maze,M,N,X,Y2,Neibs3,[]).

get_neighbor(Maze,M,N,X,Y,Neibs,NeibsR):-
    X>0,X=<M,Y>0,Y=<N,!,
    Maze[X,Y] @= Cij,
    Cij=node(No,V),
    (V==1->Neibs=NeibsR;Neibs=[No|NeibsR]).
get_neighbor(_Maze,_M,_N,_X,_Y,Neibs,Neibs).

output(Maze,M,N):-
    foreach(X in 1..M, Y in 1..N,
            [Axy,No],
            (Maze[X,Y] @= Axy,
             (Axy=node(No,0)->format("empty(~w,~w). ",[X,Y]);format("wall(~w,~w). ",[X,Y])))).
/*
test:-
     solve([row(1),row(2),row(3),row(4),row(5),col(1),col(2),col(3),col(4),col(5),entrance(1,2),exit(5,4),wall(3,3),empty(3,4)]).
*/
/*
A solution to the test instance
##### 
> # #
# # #
#   >
#####
*/

test:-
     solve([row(1),row(2),row(3),row(4),row(5),row(6),row(7),row(8),row(9),col(1),col(2),col(3),col(4),col(5),col(6),col(7),col(8),col(9),entrance(1,2),exit(5,4),wall(3,3),empty(3,4)]).


    
    
