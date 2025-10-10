/*
    Triangularize a given matrix (Gaussian elimination) (for B-Prolog).
    by Neng-Fa Zhou, Feb. 16, 2010
*/
triangle_matrix(Matrix):-
    foreach(I in 1..Matrix^length-1,
          [Row,J],                              % Row and J are local
          (select_nonzero_row(I,I,Matrix,J)->
              (I\==J->(Row @= Matrix[I],        % swap row I and J
                   Matrix[I] @:= Matrix[J],
                   Matrix[J] @:= Row)
                ;
                    true
                ),
               foreach(K in I+1..Matrix^length,trans_row(I,K,Matrix))
            ;
               true
             )).
           
% select a row J where  Matrix[J,I] is not zero
select_nonzero_row(I,J0,Matrix,J):-
    Matrix[J0,I]=\=0,!,J=J0.
select_nonzero_row(I,J0,Matrix,J):-
    J0 < Matrix^length,
    J1 is J0+1,
    select_nonzero_row(I,J1,Matrix,J).

% transform row K to make Matrix[K,I] zero
trans_row(I,K,Matrix):-
    Matrix[K,I]=:=0,!.   % is already zero
trans_row(I,K,Matrix):-
    foreach(J in I+1..Matrix[K]^length,
          [NewCoe],
          (NewCoe is Matrix[K,J]/Matrix[K,I]-Matrix[I,J]/Matrix[I,I],
           Matrix[K,J] @:= NewCoe)),
    Matrix[K,I] @:= 0.

go:-test.

test:-
    matrix(Ls),
    lists_to_matrix(Ls,Matrix),
    triangle_matrix(Matrix),
    matrix_to_lists(Matrix,Ls1),
    foreach(L in Ls1, writeln(L)),
    nl,nl,
    fail.

lists_to_matrix(Ls,Matrix):-
    new_array(Matrix,[Ls^length,Ls[1]^length]),
    foreach(I in 1..Ls^length, J in 1..Ls[1]^length,
          Matrix[I,J] is Ls[I,J]).
    
matrix_to_lists(Matrix,Ls):-
    Ls @= [Row : I in 1..Matrix^length,[Row], 
	         (Row @=[Matrix[I,J] : J in 1..Matrix[I]^length])].	    

matrix(M):-
    M=[[1,1,1,0],
       [1,-2,2,4],
       [1,2,-1,2]].

matrix(M):-
    M=[[2,1,-1,8],
       [-3,-1,2,-11],
       [-2,1,2,-3]].

matrix(M):-
    M=[[2,-3,-1,2,3,4],
       [4,-4,-1,4,11,4],
       [2,-5,-2,2,-1,9],
       [0,2,1,0,4,-5]].


    


