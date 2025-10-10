%   File   : marriage.pl
%   Author : Neng-Fa ZHOU
%   Date   : 2001
%   Purpose: solve the stable pair match puzzle
/*
There is a group of women and a group of the same number of men. Each person has expressed his/her ranking 
for the members in the opposite group. The problem is to find a matching between the two groups such that 
the marriages are stable. A marriage between a man m and a woman w is said to be stable provided that:

   if m prefers another woman o over w, o prefers her spouse over m.
   if w prefers another man o over  m, o prefers her spouse over  w.

The following are the rankings:

Men 		                      
1. Richard [5,1,2,4,3]
2. Jame   [4,1,3,2,5]
3. John   [5,3,2,4,1]
4. Hugh  [1,5,4,3,2]
5. Greg   [4,3,2,1,5]

Women
1.Helen [1,2,4,3,5]	
2.Tracy [3,5,1,2,4]	
3. Linda [5,4,2,1,3]
4. Sally [1,3,5,4,2]
5.Wanda [4,2,3,5,1]

For example Wanda is Richard's most favoriate choice and Linda is Richard's least favoriate choice.
*/
go:-
    cgWindow(Win,"marriage"),Win^topMargin #= 50,
    handleWindowClosing(Win),
    marriage(Os),
    cgSame(Os,window,Win),
    cgShow(Os).

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).

marriage(Os):-
    Men=a(Richard,Jame,John,Hugh,Greg),
    Women=a(Helen,Tracy,Linda,Sally,Wanda),
    Vars=[Richard,Jame,John,Hugh,Greg,Helen,Tracy,Linda,Sally,Wanda],
    Vars in 1..5,
    %
    men(MenRankings),
    women(WomenRankings),
    stable(Men,Women,MenRankings,WomenRankings,1,5),
    stable(Women,Men,WomenRankings,MenRankings,1,5),
    labeling(Vars),
    % display the solutions
    output(Men,Os).

% For each man M, if M chooses W then W must choose M to form a pair.
% The pair M and W must be stable
stable(Men,Women,MenRankings,WomenRankings,M,Arity):-M>Arity,!.
stable(Men,Women,MenRankings,WomenRankings,M,Arity):-
    arg(M,Men,PartnerOfM),       %M choose PartnerOfM
    nth_arg(PartnerOfM,Women,M), %PartnerOfM must choose M to form a pair
    arg(M,MenRankings,p(Name,MRanking)),
    nth_arg(PartnerOfMpos,MRanking,PartnerOfM), % PartnerOfM is ranked PartnerOfMpos by M
    stablePair(M,MRanking,PartnerOfMpos,Women,WomenRankings,1,5),
    M1 is M+1,
    stable(Men,Women,MenRankings,WomenRankings,M1,Arity).

% For each women W, if M likes his partner more than W, then W likes her spouse more than M
stablePair(M,MRanking,PartnerOfMpos,Women,WomenRankings,W,Arity):-W>Arity,!.
stablePair(M,MRanking,PartnerOfMpos,Women,WomenRankings,W,Arity):-
    nth_arg(Wpos,MRanking,W), %W is ranked Wpos by M
    arg(W,WomenRankings,p(Name,WRanking)),
    arg(W,Women,PartnerOfW), % W choose PartnerOfW
    nth_arg(Mpos,WRanking,M), %M is ranked Mpos by W
    nth_arg(PartnerOfWpos,WRanking,PartnerOfW), %PartnerOfW is ranked PartnerOfWpos by W
    Wpos #< PartnerOfMpos #=> PartnerOfWpos #< Mpos, 
             %if M likes W more than his partner, then W likes her partner more than M
    W1 is W+1,
    stablePair(M,MRanking,PartnerOfMpos,Women,WomenRankings,W1,Arity).

nth_arg(I,a(A1,A2,A3,A4,A5),V):-
    V#=A1 #=> I#=1,  I#=1 #=> V#=A1,
    V#=A2 #=> I#=2,  I#=2 #=> V#=A2,
    V#=A3 #=> I#=3,  I#=3 #=> V#=A3,
    V#=A4 #=> I#=4,  I#=4 #=> V#=A4,
    V#=A5 #=> I#=5,  I#=5 #=> V#=A5.

men(ranking(p('Richard',a(5,1,2,4,3)),
	    p('Jame',a(4,1,3,2,5)),
	    p('John',a(5,3,2,4,1)),
	    p('Hugh',a(1,5,4,3,2)),
	    p('Greg',a(4,3,2,1,5)))).

women(ranking(p('Helen',a(1,2,4,3,5)),
	      p('Tracy',a(3,5,1,2,4)),
	      p('Linda',a(5,4,2,1,3)),
	      p('Sally',a(1,3,5,4,2)),
	      p('Wanda',a(4,2,3,5,1)))).

%%%%%%%%%
output(Men,Os):-
    MenLabels=a(Lrichard,Ljame,Ljohn,Lhugh,Lgreg),
    WomenLabels=a(Lhelen,Ltracy,Llinda,Lsally,Lwanda),
    Labels=[Lrichard,Ljame,Ljohn,Lhugh,Lgreg,Lhelen,Ltracy,Llinda,Lsally,Lwanda],
    cgLabel(Labels,["Richard","Jame","John","Hugh","Greg","Helen","Tracy","Linda","Sally","Wanda"]),
    cgTable([[Lrichard,Ljame,Ljohn,Lhugh,Lgreg],
	     [Lhelen,Ltracy,Llinda,Lsally,Lwanda]],0,50),
    cgSame(Labels,fontSize,14),
    cgSetAlignment(Labels,center),
    Lines=a(L1,L2,L3,L4,L5),
    cgLine([L1,L2,L3,L4,L5]),
    constrainLines(Lines,Men,MenLabels,WomenLabels,1,5),
    Os=[L1,L2,L3,L4,L5|Labels].

constrainLines(Lines,Men,MenLabels,WomenLabels,M,N):-M>N,!.
constrainLines(Lines,Men,MenLabels,WomenLabels,M,N):-
    arg(M,Lines,Line),
    arg(M,Men,W),
    arg(M,MenLabels,MLabel),
    arg(W,WomenLabels,WLabel),
    Line^x1 #= MLabel^centerX, Line^y1 #= MLabel^bottomY,
    Line^x2 #= WLabel^centerX, Line^y2 #= WLabel^y,
    M1 is M+1,
    constrainLines(Lines,Men,MenLabels,WomenLabels,M1,N).
    

    
    


