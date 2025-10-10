go:-
    cgWindow(Win,"testList"),
    Win^leftMargin #= 100, Win^topMargin#= 100,

    cgList(L),cgAdd(L,["one","two","three","four","five","six","seven"]),
    cgChoice(C),cgAdd(C,["one","two","three"]),
    cgCheckbox([Cb1,Cb2,Cb3],["one","two","three"]),
    
    cgCheckboxGroup([Cb1,Cb2,Cb3]),

    L^width #> 100,
    L^y #> 200,
    
    cgGrid([[L,C,Cb1,Cb2,Cb3]]),
    Comps=[L,C,Cb1,Cb2,Cb3],
    cgSame(Comps,window,Win),
    cgShow(Comps),
    showListSelected(L),
    showChoiceSelected(C).

showListSelected(L),{itemStateChanged(L)} =>
    cgSelectedItems(L,Items),    
    write_strings(Items).

showChoiceSelected(C),{itemStateChanged(C)} =>
    cgSelectedItem(C,Item),    
    format("~s~n",Item).

write_strings([S|Ss]):-
    format("~s~n",S),
    write_strings(Ss).
write_strings([]).



