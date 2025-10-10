go:-
    statistics(runtime,[Start|_]),
    top,
    statistics(runtime,[End|_]),
    T is End-Start,
    write('execution time is '),write(T), write(milliseconds),nl.

top:-
    magicSquare(7).

magicSquare(N) :- 
    new_array(Matrix,[N,N]),
    NN is N*N,
    term_variables(Matrix,Vars),
    Vars :: 1..NN,
    Sum is NN*(NN+1)//(2*N),
    Matrix^rows @=Rows,
    foreach(Row in Rows, sum(Row)#=Sum),
    Matrix^columns @=Cols,
    foreach(Col in Cols, sum(Col)#=Sum),
    Matrix^diagonal1 @= Diag1,
    sum(Diag1) #= Sum,
    Matrix^diagonal2 @= Diag2,
    sum(Diag2) #= Sum,
    all_different(Vars),
    labeling([ffc],Vars),
    foreach(Row in Rows, (foreach(I in Row, format("~4d ",[I])),nl)).

