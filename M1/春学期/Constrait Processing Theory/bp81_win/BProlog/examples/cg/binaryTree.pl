go:-
    cgWindow(Win,"binaryTree"), Win^topMargin #= 50, Win^leftMargin#=10,
    Win^width #= 1000,
    handleWindowClosing(Win),    
    N=6, %depth of the tree
    generateTree(Tree,N,Os,[],Ls,[]),
    cgTree(Tree,top_down,0,4,centered),
    cgSame(Os,window,Win), cgSame(Ls,window,Win),
    cgPack(Os), % packs the nodes
    cgStartRecord(binaryTree),
    cgShow(Ls), % shows lines first
    cgShow(Os), % shows the nodes
    cgStopRecord.

generateTree(node(C,[]),0,[C|OsR],OsR,Ls,Ls):-!,node(C).
generateTree(node(Root,[C1,C2]),N,[Root|Os],OsR,[L1,L2|Ls],LsR):-
    node(Root),
    N1 is N-1,
    cgLine([L1,L2]),
    generateTree(C1,N1,Os,Os1,Ls,Ls1),C1=node(Circle1,_),
    generateTree(C2,N1,Os1,OsR,Ls1,LsR),C2=node(Circle2,_),
    L1^point1 #= Root^centerPoint,
    L1^point2 #= Circle1^centerPoint,
    L2^point1 #= L1^point1,
    L2^point2 #= Circle2^centerPoint.

node(C):-cgCircle(C),C^color #= red,C^width #= 15.

handleWindowClosing(Win),{windowClosing(Win)} => cgClose(Win).


