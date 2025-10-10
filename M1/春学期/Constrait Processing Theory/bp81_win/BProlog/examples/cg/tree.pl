go:-
    cgWindow(Win,"trie"),Win^topMargin #= 30, Win^leftMargin#=10, 
    Os=[S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16],
    Labs=[" ","b","s","t","e","t","l","a","a","a","o","i","k","r","r","w","l"],
    cgString(Os,Labs),
    cgSame(Os,window,Win), 
    cgSame(Os,fontSize,14),
    cgSame(Os,fontName,Helvetica),
    cgSame(Os,fontStyle,bold),
    Tree=node(S0,
              [node(S1,
                    [node(S4,
			  [node(S8,
				[node(S12,[]),
				 node(S13,[])])])]),
	       node(S2,
		    [node(S5,
			  [node(S9,
				[node(S14,[])])]),
		     node(S6,
			  [node(S10,
				[node(S15,[])])])]),
	       node(S3,
		    [node(S7,
			  [node(S11,
				[node(S16,[])])])])]),
    cgTree(Tree,top_down,20,20,centered),
    connectTree(Tree,Ls,[]),
    cgSame(Ls,window,Win),
    cgShow(Os),
    cgShow(Ls).

connectTrees([],Ls,LsR):-Ls=LsR.
connectTrees([C|Cs],Ls,LsR):-
    connectTree(C,Ls,Ls1),
    connectTrees(Cs,Ls1,LsR).

connectTree(node(Box,[]),Ls,LsR):-!,Ls=LsR.
connectTree(node(Box,Chs),Ls,LsR):-
    connectChildren(Box,Chs,Ls,Ls1),
    connectTrees(Chs,Ls1,LsR).

connectChildren(Box,[],Ls,LsR):-Ls=LsR.
connectChildren(Box,[node(C,_)|Cs],Ls,LsR):-
    cgLine(L),
    Ls=[L|Ls1],
    L^y1 #= Box^bottomY, L^y2 #= C^y,
    L^x1 #= Box^centerX, L^x2 #= C^centerX,
    connectChildren(Box,Cs,Ls1,LsR).
    
