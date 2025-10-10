go:-
    cgWindow(W,"testWindowEvent"),
    W^topMargin #= 100, W^leftMargin #= 100,
    cgTextField(T,"                      "),
    T^window #= W,
    handleClosing(W,T),
    handleOpened(W,T),
    handleIconified(W,T),
    handleDeiconified(W,T),
    handleClosed(W,T),
    handleActivated(W,T),
    handleDeactivated(W,T),
    cgShow(T).

handleClosing(W,T),{windowClosing(W)} =>
    outmessage(T,"windowClosing").

handleOpened(W,T),{windowOpened(W)} =>
    outmessage(T,"windowOpened").

handleIconified(W,T),{windowIconified(W)} =>
    outmessage(T,"windowIconified").

handleDeiconified(W,T),{windowDeiconified(W)} =>
    outmessage(T,"windowDeiconified").

handleClosed(W,T),{windowClosed(W)} =>
    outmessage(T,"windowClosed").

handleActivated(W,T),{windowActivated(W)} =>
    outmessage(T,"windowActivated").

handleDeactivated(W,T),{windowDeactivated(W)} =>
    outmessage(T,"windowDeactivated").

outmessage(T,EventType):-
    format("~s~n",EventType),
    cgSetText(T,EventType).

