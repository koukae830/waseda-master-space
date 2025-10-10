go:-
    timer(T1,100), % timer_start(T1),
    timer(T2,1000), %timer_start(T2),
    ping(T1),
    pong(T2),
    loop.


ping(T),{time(T)} => write(ping),nl.

pong(T),{time(T)} => write(pong),nl.

loop:-loop.
