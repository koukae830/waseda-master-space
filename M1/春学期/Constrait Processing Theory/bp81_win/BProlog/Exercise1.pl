send_more_money :-
    Digits = [0,1,2,3,4,5,6,7,8,9],
    member(S, Digits), S =\= 0,
    member(E, Digits), E =\= S,
    member(N, Digits), N =\= S, N =\= E,
    member(D, Digits), D =\= S, D =\= E, D =\= N,
    member(M, Digits), M =\= 0, M =\= S, M =\= E, M =\= N, M =\= D,
    member(O, Digits), O =\= S, O =\= E, O =\= N, O =\= D, O =\= M,
    member(R, Digits), R =\= S, R =\= E, R =\= N, R =\= D, R =\= M, R =\= O,
    member(Y, Digits), Y =\= S, Y =\= E, Y =\= N, Y =\= D, Y =\= M, Y =\= O, Y =\= R,

    Send is 1000*S + 100*E + 10*N + D,
    More is 1000*M + 100*O + 10*R + E,
    Money is 10000*M + 1000*O + 100*N + 10*E + Y,

    Sum is Send + More,
    Sum =:= Money,

    write([S,E,N,D,M,O,R,Y]), nl.
