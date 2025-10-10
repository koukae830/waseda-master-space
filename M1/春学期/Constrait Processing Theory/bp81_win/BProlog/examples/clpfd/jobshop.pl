/*
task1 : machine1, duration=2
task2 : machine1, duration=3
task3 : machine2, duration=1
task4 : machine2, duration=2
task5 : machine1, duration=3
task6 : machine2, duration=4
task7 : machine1, duration=2
task8 : machine2, duration=3
*/
tasks([task(1,1,_,2),
       task(2,1,_,3),
       task(3,2,_,1),
       task(4,2,_,2),
       task(5,1,_,3),
       task(6,2,_,4),
       task(7,1,_,2),
       task(8,2,_,3)]).

go:-
    tasks(Ts),
    vars_and_maximum_time(Ts,Starts,Ends,0,MaxTime),
    Starts in 0..MaxTime,
    max(Ends) #= MaxEnd,
    constrain(Ts),
    fd_minimize(labeling_ff(Starts),MaxEnd),
    write(Ts),nl.
    
vars_and_maximum_time([],[],[],MaxTime,MaxTime).
vars_and_maximum_time([task(Id,M,Start,Duration)|Tasks],[Start|Starts],[End|Ends],MaxTime0,MaxTime):-
    MaxTime1 is MaxTime0+Duration,
    End #= Start+Duration,
    vars_and_maximum_time(Tasks,Starts,Ends,MaxTime1,MaxTime).

constrain([]).
constrain([T|Ts]):-
    constrain(T,Ts),
    constrain(Ts).

constrain(T,[]).
constrain(Task,[task(Id1,M1,S1,D1)|Ts]):-
    Task=task(Id,M,S,D),
    (M1==M->
     (S+D #=< S1 #\/ S1+D1 #=< S);
      true),
     constrain(Task,Ts).

      
