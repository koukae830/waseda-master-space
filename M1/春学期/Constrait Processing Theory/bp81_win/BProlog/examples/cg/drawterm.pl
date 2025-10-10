/**
*A program for visualizing Prolog terms as trees.
*by ROOSEVELT VICTOR, modified by Neng-Fa Zhou
**/
go :- 
    cgWindow(W,"Draw Prolog terms, by Roosevelt Victor"),
    W^width#=600,
    W^height#=400,W^leftMargin#= 20, 
    W^topMargin#=30,
    %
    cgTextField(Input), 
    Input^width#=W^width/2,
    Input^fontSize #= 10, Input^fontStyle#=bold,
    %
    cgChoice(Choice),
    read_sentences(Sentences),
    cgAdd(Choice,Sentences),
    %
    cgButton(B,"Draw"), 
    %
    cgTable([[Input,B],
	    [Choice,B]]),

    cgRectangle(Area),
    Area^fill#=0, 
    W^width#=Area^width,
    W^height#=Area^height,
    cgAbove(B,Area),
    %
    Comps=[Input,Choice,Area,B],
    cgSame(Comps,window,W),
    selectTerm(Choice,Input,Area,W,Comps),
    handleWindClose(W),
    handleWindResized(W,Comps),
    %
    cgSetText(Input,"p(q(a,r(b,c)),s(u,v))"),
    handleDraw(B,Input,Area,W,Comps),
    cgStartRecord(drawTerm),
    doDraw(Input,Area,W,Comps),
    cgStopRecord.

/***
*Draws the tree when the Button B is clicked
*/
handleDraw(B,Input,Area,Win,Comps),{actionPerformed(B)} =>
    catch(doDraw(Input,Area,Win,Comps),_,true). %ignore exception

doDraw(Input,Area,Win,Comps):-
    cgGetText(Input,Text),
    (parse_string(Text,Term) ->
     termTree(Term,Tree), %convert Prolog term to a tree structure required by cgTree
     Tree=node(Box,_), Box^y #= Area^y+30,
     cgTree(Tree,top_down,2,20,centered),
     connectTree(Tree,Os,[],Ls,[]),
     cgSame(Os,window,Win),cgSame(Ls,window,Win),
     cgCleanDrawing(Win),
     cgShow(Comps),cgShow(Os),cgShow(Ls);
     true).

termTree(Term,Tree):-var(Term),!,
    Term=v,
    termTree(Term,Tree).
termTree(Term,Tree):-atomic(Term),!,
    Tree=node(Box,[]),
    createNode(Box,Term).
termTree(Term,Tree):-
    Tree=node(Box,Children),
    functor(Term,Name,N),
    createNode(Box,Name),
    termTree(Term,1,N,Children).

termTree(Term,N0,N,Trees):-N0>N,!,Trees=[].
termTree(Term,N0,N,Trees):-
    Trees=[Tree|Trees1],
    arg(N0,Term,SubTerm),
    termTree(SubTerm,Tree),
    N1 is N0+1,
    termTree(Term,N1,N,Trees1).

connectTree(node(Box,Children),Os,OsR,Ls,LsR):-
    Os=[Box|Os1],
    connectChildren(Box,Children,Os1,OsR,Ls,LsR).

connectChildren(Box,[],Os,OsR,Ls,LsR):-!,Os=OsR,Ls=LsR.
connectChildren(Box,[Child|Children],Os,OsR,Ls,LsR):-
    connectChild(Box,Child,Line),
    Ls=[Line|Ls1],
    connectTree(Child,Os,Os1,Ls1,Ls2),
    connectChildren(Box,Children,Os1,OsR,Ls2,LsR).

connectChild(Box,node(CBox,_),Line):-
    cgLine(Line), 
    Line^x1 #= Box^centerX, Line^y1 #= Box^bottomY,
    Line^x2 #= CBox^centerX, Line^y2 #= CBox^y.

createNode(Box,Term):-
    name(Term,Text),
    cgTextBox(Box),
    cgSetText(Box,Text), 
    cgSetAlignment(Box,center),
    Box^color#=blue,Box^fontSize#=10.
    
handleWindClose(W),{windowClosing(W)}=>cgClose(W).

handleWindResized(Win,[Input,Choice,Area,B]),{componentResized(Win,E)} =>
    Area^width #:= E^width,
    Area^height #:=E^height,
    cgShow([Input,Area,B]).

selectTerm(Choice,Input,Area,Win,Comps),{itemStateChanged(Choice,E)} =>
    cgSelectedItem(Choice,Text),
    cgSetText(Input,Text),
    doDraw(Input,Area,Win,Comps).    

read_sentences(Sentences):-
    see('terms.pl'),
    read(Term),
    read_sentences(Term,Sentences).

read_sentences(end_of_file,Sentences):-!,seen,Sentences=[].
read_sentences(Term,Sentences):-
    Sentences=[String|SentencesR],
    term2string(Term,String),
    read(NextTerm),
    read_sentences(NextTerm,SentencesR).

    
