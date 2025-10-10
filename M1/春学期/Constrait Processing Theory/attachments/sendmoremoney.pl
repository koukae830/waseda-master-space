smm(Vars):-
	Vars=[S,E,N,D,M,O,R,Y],

	Range=[0,1,2,3,4,5,6,7,8,9],
	member(S,Range),             % domain for S
	member(E,Range),             % domain for E
	member(N,Range),             % domain for N
	member(D,Range),             % domain for D
	member(M,Range),             % domain for M
	member(O,Range),             % domain for O
	member(R,Range),             % domain for R
	member(Y,Range),             % domain for Y
	
	S\=E, S\=N, S\=D, S\=M, S\=O, S\=R, S\=Y,
	      E\=N, E\=D, E\=M, E\=O, E\=R, E\=Y,
		    N\=D, N\=M, N\=O, N\=R, N\=Y,
			  D\=M, D\=O, D\=R, D\=Y,
				M\=O, M\=R, M\=Y,
				      O\=R, O\=Y,
					    R\=Y,

         S\=0, M\=0,
         Part1 is 1000*S+100*E+10*N+D
                + 1000*M+100*O+10*R+E,
         Part2 is 10000*M+1000*O+100*N+10*E+Y,
	 Part1==Part2.
