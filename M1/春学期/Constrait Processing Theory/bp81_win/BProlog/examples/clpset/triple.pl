/*
Title: Seeing Triple
Solved by: Doug Edmunds
Publication: Dell Logic Puzzles
Issue: February, 2000
Page: 27
Stars: 3
Modified by Neng-Fa Zhou

Dell 2000 02 p 27 Seeing Triple 3 star
solved 13 March 2000

Notes: use of lib(conjunto) use of sets and set parts inside Units/Constraints construction.
(for clues like 2 brothers and one sister)
Slow - takes over a minute

solution: u(27, maine, {doris, lois, perry})
u(29, arizona, {clay, keri, nan})
u(31, conn, {jane, melissa, morris})
u(33, delaware, {boris, dan, faye})

*/

go:-
    cputime(Start),
    top,
    cputime(End),        	
    T is End-Start,
    write('cputime='),write(T),nl.

top:-solve(_).

solve(U) :-

U = [
     u(25,_,SV1),
     u(27,_,SV2),
     u(29,_,SV3),
     u(31,_,SV4),
     u(33,_,SV5)
], 
C = [
     u(AFlorida,florida, TRFlorida),
     u(AConn, conn, TRConn),
     u(AMaine,maine, TRMaine),
     u(ADelaware, delaware, TRDelaware),
     u(AArizona, arizona, TRArizona),
     u(ABORIS,_,TRBORIS), 
     u(ACLAY,_,TRCLAY), 
     u(ADAN,_,TRDAN), 
     u(AMORRIS,_,TRMORRIS), 
     u(APERRY,_,TRPERRY), 
     u(ARAY,_,TRRAY), 
     u(AWAYNE,_,TRWAYNE),
     u(AANN,_,TRANN), 
     u(ADORIS,_,TRDORIS), 
     u(AFAYE,_,TRFAYE), 
     u(AJANE,_,TRJANE), 
     u(AKERI,_,TRKERI), 
     u(ALOIS,_,TRLOIS), 
     u(AMELISSA,_,TRMELISSA), 
     u(ANAN,_,TRNAN)
     ],

    [AFlorida,AConn,AMaine,ADelaware,AArizona,
     ABORIS, ACLAY, ADAN, AMORRIS, APERRY, ARAY, AWAYNE,
     AANN, ADORIS, AFAYE, AJANE, AKERI, ALOIS, AMELISSA, ANAN] 
    in [25,27,29,31,33],

    alldifferent([AFlorida,AConn,AMaine,ADelaware,AArizona]),

    [TRFlorida,TRConn,TRMaine,TRDelaware,TRArizona,
     TRBORIS, TRCLAY, TRDAN, TRMORRIS, TRPERRY, TRRAY, TRWAYNE,
     TRANN, TRDORIS, TRFAYE, TRJANE, TRKERI, TRLOIS, TRMELISSA, TRNAN] 
    :: 
    {}..{boris,clay,dan,morris,perry,ray,wayne,
	 ann,doris,faye,jane,keri,lois,melissa,nan},

    #(TRFlorida) #= 3,
    #(TRConn) #= 3,
    #TRMaine #= 3,
    #TRDelaware #= 3,
    #TRArizona #= 3,
    #TRBORIS #= 3, 
    #TRCLAY #= 3,
    #TRDAN #= 3,
    #TRMORRIS #= 3,
    #TRPERRY #= 3,
    #TRRAY #= 3,
    #TRWAYNE #= 3,

    #TRANN #= 3,
    #TRDORIS #= 3, 
    #TRFAYE #= 3,
    #TRJANE #= 3,
    #TRKERI #= 3,
    #TRLOIS #= 3,
    #TRMELISSA #= 3,
    #TRNAN #= 3,

    Triplet_Sets = [TRFlorida,TRConn,TRMaine,TRDelaware,TRArizona],
    all_disjoint(Triplet_Sets),

    boris #<- TRBORIS,
    clay #<- TRCLAY, 
    dan #<- TRDAN, 
    morris #<- TRMORRIS, 
    perry #<- TRPERRY, 
    ray #<- TRRAY, 
    wayne #<- TRWAYNE,
    ann #<- TRANN, 
    doris #<- TRDORIS, 
    faye #<- TRFAYE,
    jane #<- TRJANE,
    keri #<- TRKERI, 
    lois #<- TRLOIS, 
    melissa #<- TRMELISSA, 
    nan #<- TRNAN,

    %clue 1
    AWAYNE ## 33,
    BWAYNE :: {}..{clay,dan,morris,perry,ray},
    #BWAYNE #= 1,
    BWAYNE subset TRWAYNE,
    SWAYNE :: {}..{ann,doris,faye,jane,keri,lois,melissa,nan},
    #SWAYNE #= 1,
    SWAYNE subset TRWAYNE,

    %clue 2
    TRMELISSA ## TRDAN,
    TRNAN ## TRDAN,

    %clue3
    TRJANE ## TRBORIS,
    TRJANE ## TRNAN,
    TRBORIS ## TRNAN,
    TRNAN ## TRRAY,
    AJANE #= ABORIS-2,
    AJANE #= ANAN + 2,

    %clue4
    TRLOIS ## TRKERI,
    TRLOIS ## TRConn,
    TRKERI ## TRConn,
    ALOIS #= AKERI - 2,
    AKERI #= AConn - 2, 

    BLOIS :: {}..{boris,clay,dan,morris,perry,ray,wayne},
    #BLOIS #= 1,
    BLOIS subset TRLOIS,
    SLOIS :: {}..{ann,doris,faye,jane,keri,melissa,nan},
    #SLOIS #= 1,
    SLOIS subset TRLOIS,

    %clue5
    TRDelaware ## TRRAY,
    TRRAY ## TRLOIS,
    
    %clue6
    BArizona :: {}..{boris,clay,dan,morris,perry,ray,wayne},
    #BArizona #= 1,
    BArizona subset TRArizona,
    SArizona :: {}..{ann,doris,faye,jane,keri,lois,melissa,nan},
    #SArizona #= 2,
    SArizona subset TRArizona,

    %clue7
    TRBORIS ## TRPERRY,
    TRPERRY ## TRKERI,

    BBORIS :: {}..{clay,dan,morris,perry,ray,wayne},
    #BBORIS #= 1,
    BBORIS subset TRBORIS,
    SBORIS :: {}..{ann,doris,faye,jane,keri,lois,melissa,nan},
    #SBORIS #= 1,
    SBORIS subset TRBORIS,

    %clue 8
    TRDORIS #= TRMaine,
    TRDORIS ## TRNAN,

    %clue9
    TRFlorida ## TRBORIS, 
    TRBORIS ## TRDORIS,

    %clue10
    TRNAN ## TRMORRIS,

    %clue11
    TRMORRIS #= TRConn,

    TRMORRIS :: {}..{morris,ann,doris,faye,jane,keri,lois,melissa,nan},

    %clue12
    AANN in [25,27,29],

    %clue13
    ADORIS ##25,

    mysubset(C,U),
    (member(Unit,U),write(Unit),nl,fail;true).


mysubset([],_).
mysubset([H|T],List) :-
    member(H,List),
    mysubset(T,List).

all_disjoint([S|Ss]):-
    all_disjoint(S,Ss),
    all_disjoint(Ss).
all_disjoint([]).

all_disjoint(S,[]).
all_disjoint(S,[R|Rs]):-
    S #<> R,
    all_disjoint(S,Rs).

% © Copyright Doug Edmunds 2000 

