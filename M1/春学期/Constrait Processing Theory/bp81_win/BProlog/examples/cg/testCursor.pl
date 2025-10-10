go:-
    cgWindow(W,"testCursor"),
    W^topMargin #= 100, W^leftMargin #= 100,
    cgButton(B,"ClickMeToChangeCursor"),
    B^window #= W,
    B^fontSize #= 16,
    changeCursor(B),
    cgShow(B).

changeCursor(B),{actionPerformed(B)} =>
    cgGetCursor(B,Cursor0),
    cursors(Cursors),
    (append(_,[Cursor0,Cursor1|_],Cursors);
     Cursors=[Cursor1|_]),
    cgSetCursor(B,Cursor1).

cursors([crosshair_cursor,
	 default_cursor,
	 e_resize_cursor,
	 hand_cursor,
	 move_cursor,
	 n_resize_cursor,
	 ne_resize_cursor,
	 nw_resize_cursor,
	 s_resize_cursor,
	 se_resize_cursor,
	 sw_resize_cursor,
	 text_cursor,
	 w_resize_cursor,
	 wait_cursor]).

    
