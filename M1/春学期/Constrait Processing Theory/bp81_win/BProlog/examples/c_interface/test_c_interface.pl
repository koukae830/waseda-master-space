test_interface_prolog_pred(X,L):-X>100,!,write(L),nl.
test_interface_prolog_pred(X,L):-
    write(test_interface_c_pred(X,L)),nl,
    write(X),
    attach(X,L),
    test_interface_c_pred(X,L).
    
