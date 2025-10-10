father(old_jack, jack).
father(jack, jack_jr).
father(jack_jr, little_jack).

ancestor(X, Y) :- 
    father(X, Y).

% 规则 2：递归——如果 X 是 Z 的父亲，且 Z 是 Y 的祖先，则 X 也是 Y 的祖先
ancestor(X, Y) :- 
    father(X, Z),
    ancestor(Z, Y).




