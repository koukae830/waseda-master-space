go:-
    cgWindow(W,"testComponentEvent"),
    W^topMargin #= 100, W^leftMargin #= 100,
    cgTextField(T,"                      "),
    T^window #= W,
    handleResized(W,T),
    handleMoved(W,T),
    cgShow(T).

handleResized(W,T),{componentResized(W,E)} =>
    outmessage(T,E,"componentResized").

handleMoved(W,T),{componentMoved(W,E)} =>
    outmessage(T,E,"componentMoved").

outmessage(T,E,EventType):-
    format("~s~n",EventType),
    cgSetText(T,EventType).

