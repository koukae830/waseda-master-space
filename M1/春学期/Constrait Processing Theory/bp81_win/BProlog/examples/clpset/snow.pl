/*
Title: Snow Play
Solved by: Doug Edmunds
Publication: Dell Logic Puzzles
Issue: February, 2000
Page: 37
Stars: 4

Clues

Dell Logic Puzzles Ed:2/2000 Pg:37 Title:Snow Play (4 star)
solved 12 Jan 2000

takes 23 sec on PII350 w/ 96meg ram

correct solution
unit(id, first,last,item,activities,sex):

unit(1, anton, mishler, balaclava, {cc, dh, sb}, m)
unit(2, dean, richter, mittens, {isk, sb, ss}, m)
unit(3, bess, olivera, earmuffs, {cc, isk, ss}, f)
unit(4, erika, nguyen, scarf, {dh, isk, sb}, f)
unit(5, laurel, pearce, boots, {cc, dh, ss}, f)
*/
go:-
    cputime(Start),
    top,
    cputime(End),        	
    T is End-Start,
    write('cputime='),write(T),nl.

top:-
    start(_).

start(Units) :-
    Units = 
    [
     unit(1,anton ,_,_,_,m),
     unit(2,dean ,_,_,_,m),
     unit(3,bess ,_,_,_,f),
     unit(4,erika ,_,_,_,f),
     unit(5,laurel,_,_,_,f)
     ],

    Firsts = [Fanton, Fdean, Fbess, Ferika,Flaurel],
    Firsts :: 1..5,
    Lasts = [Fmishler,Fnguyen,Folivera,Fpearce,Frichter],
    Lasts :: 1..5,
    Items = [Fmittens, Fearmuffs, Fscarf, Fbalaclava,Fboots],
    Items :: 1..5,

    [Aperson1,Aperson2, Aperson3, Aperson4,
     Apearce, Anguyen, Arichter, Amishler, Aolivera,
     Aearmuffs, Ascarf, Amittens,
     Aanton,Adean,Abess, Aerika, Alaurel] 
    :: {}..{cc, dh, isk, sb, ss},

    #Apearce #= 3,
    #Arichter#=3,
    #Amishler#=3,
    #Aolivera#=3,
    #Anguyen#=3,
    #Aearmuffs#=3,
    #Ascarf#=3,
    #Amittens#=3,
    #Aanton#=3,
    #Adean#=3,
    #Abess#=3,
    #Aerika#=3,
    #Alaurel#=3,
    #Aperson1#=3,
    #Aperson2#=3,
    #Aperson3#=3,
    #Aperson4#=3,


    A_Mystery1 :: [cc, dh, isk, sb, ss],

    Constraints =
    [
     unit(Fanton ,anton ,_,_,Aanton ,_),
     unit(Fdean ,dean ,_,_,Adean ,_),
     unit(Fbess ,bess ,_,_,Abess ,_),
     unit(Ferika ,erika ,_,_,Aerika ,_),
     unit(Flaurel,laurel,_,_,Alaurel,_),
     
     unit(Fmishler,_,mishler,_,Amishler,_),
     unit(Fnguyen ,_,nguyen ,_,Anguyen,f), % f- clue5
     unit(Folivera,_,olivera,_,Aolivera,_),
     unit(Fpearce ,_,pearce ,_,Apearce,_),
     unit(Frichter,_,richter,_,Arichter,_),

     unit(Fmittens ,_,_,mittens ,Amittens,_),
     unit(Fearmuffs ,_,_,earmuffs ,Aearmuffs,_),
     unit(Fscarf ,_,_,scarf ,Ascarf,_),
     unit(Fbalaclava,_,_,balaclava ,_,_),
     unit(Fboots ,_,_,boots ,_,_),
     
     unit(F_ISK_SB_SS, _,_,_, {isk,sb,ss},_),

     unit(Fperson1 ,_,_,_, Aperson1,_),
     unit(Fperson2 ,_,_,_, Aperson2,_),

     unit(Fperson3 ,_,_,_, Aperson3,_),
     unit(Fperson4 ,_,_,_, Aperson4,_)
     ],

% relationships

%clue1
    Fearmuffs #\= Fanton,
    Fearmuffs #\= Fnguyen,

%clue2
    Fpearce #\= Ferika,
    dh #<- Apearce,
    dh #<- Aerika,
    Aerika /\ Apearce #= {dh},

%clue3
    Fmittens #\= Fbess,
    Fmittens #\= Flaurel,
    indomain(A_Mystery1),
    A_Mystery1#<- Abess,
    A_Mystery1#<- Alaurel,
    A_Mystery1#<- Amittens,

    Fperson3 #\= Fperson4,
    A_Mystery1#<\- Aperson3,
    A_Mystery1#<\- Aperson4,

%clue4
    Fearmuffs #\= Fdean,
    Fscarf #\= Fdean,
    isk #<- Adean,
    isk #<- Aearmuffs,
    isk #<- Ascarf,

    Fperson1 #\= Fdean,
    Fperson1 #\= Fscarf,
    Fperson1 #\= Fearmuffs,
    Fperson2 #\= Fdean,
    Fperson2 #\= Fscarf,
    Fperson2 #\= Fearmuffs,
    Fperson1 #\= Fperson2,

    isk#<\- Aperson1,
    isk#<\- Aperson2,

%clue5
    cc#<\- Anguyen,
    cc#<\- Arichter,
    cc #<- Aolivera,
    cc #<- Amishler,
    cc #<- Apearce,

%clue6
    [Flaurel, Folivera, Fbalaclava, Fscarf, F_ISK_SB_SS] :: 1..5,
    alldifferent([Flaurel, Folivera, Fbalaclava, Fscarf, F_ISK_SB_SS]),

%clue7
    Fearmuffs #\= Fmishler,
    Fearmuffs #\= Fpearce,

%clue8
    sb #<\- Abess,

%clue9
    Fboots #\= Fmishler,

    labeling([Abess,Aerika,Alaurel,Adean,Aanton]),
    psubset(Constraints, Units),
    (member(Unit,Units),writeln(Unit),fail;true).

psubset([],_).
psubset([H|T],List) :-
    member(H,List),
    psubset(T,List). 

% © Copyright Doug Edmunds 2000 
