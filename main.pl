male('Константин').
female('Надежда').
male('Кирилл').
female('Галина').
male('ЮрийН').
female('Алевтина').
male('Юрий').
female('Марина').
male('Михаил').
male('Александр').
male('Вячеслав').
child('Кирилл','Константин').
child('Кирилл','Надежда').
child('Марина','Константин').
child('Марина','Надежда').
child('Надежда','ЮрийН').
child('Надежда','Галина').
child('Александр','ЮрийН').
child('Александр','Галина').
child('Константин','Юрий').
child('Константин','Алевтина').
child('Михаил','Юрий').
child('Михаил','Алевтина').
child('Вячеслав','').
child('Вячеслав','').
child('Алевтина','').
child('Алевтина','').

samechild(X,Y):-child(Z,Y), child(Z,X),!.

sameparent(X,Y):-child(X,Z), child(Y,Z), !.

wife(X,Y):-female(X), male(Y), samechild(X,Y).

brother(X,Y):-male(X), sameparent(X,Y).

shurin(X,Y):- male(X), male(Y), wife(Z,Y), brother(X,Z).
%__________________________________________________________________________
%Поиск в глубину
search_dpth(A,B,L) :-
	dpth([A],B,L).

prolong([X|T],[Y,X|T]) :-
	child(Y,X), not(member(Y,[X|T])). 

dpth([X|T],X,[X|T]).	
dpth(P,F,L) :- prolong(P,P1), dpth(P1,F,L).


famlist(Person1,Person2,E,List1,List2):-search_dpth(E,Person1,List1),search_dpth(E,Person2,List2).
%_____________________________________________________________________________
degrel(L1,L2,W):-brother(L1,L2,W);sister(L1,L2,W);uncle(L1,L2,W).

brother([_,Pers2|_],[Pers1,Pers2|_],'sister'):-male(Pers1).
sister([_,Pers2|_],[Pers1,Pers2|_],'brother'):-female(Pers1).
uncle([Pers1,Pers2|_],[_,_,Pers2|_],'uncle'):-male(Pers1).
%__________________________________________________________________________
procchild([_|[]],[]).
procchild([Per1,Per2|T],['child'|Tail]):-
    child(Per1,Per2), procchild([Per2|T],Tail).

procparent([_|[]],[]).
procparent([Per1,Per2|T],['mother'|Tail]):-
    child(Per2,Per1),female(Per1),procparent([Per2|T],Tail).
procparent([Per1,Per2|T],['father'|Tail]):-
    child(Per2,Per1),male(Per1),procparent([Per2|T],Tail).

degree([H|[]],H).
degree([H|T],W):-degree(T,W1),string_concat(H,'-',X),string_concat(X,W1,W).
%__________________________________________________________________________
relative(W, Person1, Person2):- famlist(Person1,Person2,_,L1,L2),(degrel(L1,L2,W); 
    (procchild(L1,M1),reverse(L2,LR2),procparent(LR2,M2),append(M1,M2,M),degree(M,W))).

