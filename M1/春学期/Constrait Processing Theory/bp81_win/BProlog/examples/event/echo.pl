go:-
    echo_agent(Ping),
    echo_agent(Pong),
    post(event(Ping,ping)),
    post(event(Pong,pong)).

echo_agent(X),
        {event(X,O)}
        =>
        write(O),nl.

