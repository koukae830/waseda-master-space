go :-
        bool_queens(16).
bool_queens(A) :-
        new_array(B, [A,A]),
        F=G,
        I is 1,
        J is A,
        'bool_queens_#_0'(I, J, E, A, B, G, H),
        H=[],
        F@=C,
        C::0..1,
        true,
        K is 1-A,
        L is A-1,
        'bool_queens_#_2'(K, L, B, D, E, A),
        true,
        true,
        M is 2,
        N is 2*A,
        'bool_queens_#_5'(M, N, B, D, E, A),
        true,
        labeling(C),
        true,
        O is 1,
        P is A,
        'bool_queens_#_8'(O, P, B, E, A),
        true.
'bool_queens_#_2'(A, B, _, _, _, _) :-
        (A>B):true.
'bool_queens_#_2'(E, F, A, B, C, D) :-
        true:((((I=J,(L is 1,M is D,'bool_queens_#_3'(L,M,E,A,J,K)),K=[]),I@=H),1#>=sum(H)),G is E+1,'bool_queens_#_2'(G,F,A,B,C,D)).
'bool_queens_#_0'(A, B, _, _, _, C, D) :-
        (A>B):(C=D,true).
'bool_queens_#_0'(F, G, A, B, E, C, H) :-
        true:((J is 1,K is B,'bool_queens_#_1'(J,K,E,F,C,D)),I is F+1,'bool_queens_#_0'(I,G,A,B,E,D,H)).
'bool_queens_#_6_d_7'(A, B, C, D) :-
        D is C-B, !,
        A=1.
'bool_queens_#_6_d_7'(_, _, _, _).
'bool_queens_#_6'(A, B, _, _, C, D) :-
        (A>B):(C=D,true).
'bool_queens_#_6'(F, H, E, G, C, I) :-
        true:(('bool_queens_#_6_d_7'(K,F,E,B),('_$initialize_var'(A),'_$initialize_var'(G),'_$initialize_var'(F),'_$initialize_var'(B),'_$initialize_var'(C),'_$initialize_var'(D)),'_$if_then_else'(nonvar(K),(A@=G^[F,B],C=[A|D]),C=D)),J is F+1,'bool_queens_#_6'(J,H,E,G,D,I)).
'bool_queens_#_1'(A, B, _, _, C, D) :-
        (A>B):(C=D,true).
'bool_queens_#_1'(F, G, D, E, B, H) :-
        true:((A@=D^[E,F],B=[A|C]),I is F+1,'bool_queens_#_1'(I,G,D,E,C,H)).
'bool_queens_#_3'(A, B, _, _, C, D) :-
        (A>B):(C=D,true).
'bool_queens_#_3'(E, H, F, G, C, I) :-
        true:(('bool_queens_#_3_d_4'(K,F,E,B),('_$initialize_var'(A),'_$initialize_var'(G),'_$initialize_var'(E),'_$initialize_var'(B),'_$initialize_var'(C),'_$initialize_var'(D)),'_$if_then_else'(nonvar(K),(A@=G^[E,B],C=[A|D]),C=D)),J is E+1,'bool_queens_#_3'(J,H,F,G,D,I)).
'bool_queens_#_9'(A, B, _, _, C, D) :-
        (A>B):(C=D,true).
'bool_queens_#_9'(F, G, D, E, B, H) :-
        true:((A@=D^[E,F],B=[A|C]),I is F+1,'bool_queens_#_9'(I,G,D,E,C,H)).
'bool_queens_#_5'(A, B, _, _, _, _) :-
        (A>B):true.
'bool_queens_#_5'(E, F, A, B, C, D) :-
        true:((((I=J,(L is 1,M is D,'bool_queens_#_6'(L,M,E,A,J,K)),K=[]),I@=H),1#>=sum(H)),G is E+1,'bool_queens_#_5'(G,F,A,B,C,D)).
'bool_queens_#_8'(A, B, _, _, _) :-
        (A>B):true.
'bool_queens_#_8'(C, F, B, D, E) :-
        true:((((H=I,(K is 1,L is E,'bool_queens_#_9'(K,L,B,C,I,J)),J=[]),H@=A),writeln(A)),G is C+1,'bool_queens_#_8'(G,F,B,D,E)).
'bool_queens_#_3_d_4'(A, B, C, D) :-
        D is C-B, !,
        A=1.
'bool_queens_#_3_d_4'(_, _, _, _).
