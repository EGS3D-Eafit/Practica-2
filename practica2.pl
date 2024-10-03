% Definición del sexo de cada persona
male(john).
male(mike).
male(sam).
male(bob).
male(zack).

female(mary).
female(linda).
female(susan).
female(jane).
female(anna).

% Definición de relaciones de parentesco
parent(john, mike).
parent(john, susan).
parent(mary, mike).
parent(mary, susan).
parent(mike, sam).
parent(linda, sam).
parent(bob, linda).
parent(bob, anna).
parent(jane, bob).
parent(zack, bob).

% Definiciones de relaciones
father(X,Y):-parent(X,Y), male(X).
mother(X,Y):-parent(X,Y), female(X).

sibling(X,Y):-(parent(Z, X), parent(Z, Y) ; parent(Q, X), parent(Q, Y)), X \= Y.
brother(X,Y):-sibling(X,Y),male(X).
sister(X,Y):-sibling(X,Y),female(X).

grandparent(X,Y):-parent(X,Z),parent(Z,Y).
grandmother(X,Y):-grandparent(X,Y),female(X).
grandfather(X,Y):-grandparent(X,Y),male(X).

uncle(X,Y):-parent(Z,Y),sibling(X,Z).
unclem(X,Y):-uncle(X,Y),male(X).
aunt(X,Y):-uncle(X,Y),female(X).

cousin(X,Y):-uncle(Z,Y),parent(Z,X).
cousinm(X,Y):-cousin(X,Y),male(X).
cousinf(X,Y):-cousin(X,Y),female(X).

levelConsanguinity(X, Y, 1) :- parent(X, Y).  
levelConsanguinity(X, Y, 1) :- parent(Y, X).
levelConsanguinity(X, Y, 2) :- sibling(X,Y).
levelConsanguinity(X, Y, 2) :- grandparent(Y, X).
levelConsanguinity(X, Y, 3) :- uncle(Y, X).
levelConsanguinity(X, Y, 3) :- uncle(X, Y).
levelConsanguinity(X, Y, 3) :- cousin(Y, X).
levelConsanguinity(X, Y, 3) :- cousin(X, Y).

peopleInLevel(X, Level, Count) :- setof(Y, levelConsanguinity(X, Y, Level), People), length(People, Count).

distributeInheritance(X, InheritanceTotal) :-
    peopleInLevel(X, 1, Count1),
    ( 
        Count1 > 0 -> 
            InheritancePart1 is InheritanceTotal * 3 / 10,
            IndividualShare1 is InheritancePart1 / Count1,
            format('~w le da ~2f individualmente a sus ~d hijos y/o padres con un total de ~2f~n', [X, IndividualShare1, Count1, InheritancePart1])
        ;
            format('~w no tiene hijos ni padres a los que le pueda heredar nada.~n', [X])
    ),
    peopleInLevel(X, 2, Count2),
    ( 
        Count2 > 0 -> 
            InheritancePart2 is InheritanceTotal * 2 / 10,
            IndividualShare2 is InheritancePart2 / Count2,
            format('~w le da ~2f individualmente a sus ~d hermanos y/o abuelos con un total de ~2f~n', [X, IndividualShare2, Count2, InheritancePart2])
        ;
            format('~w no tiene hermanos ni abuelos a los que le pueda heredar nada.~n', [X])
    ),
    peopleInLevel(X, 3, Count3),
    ( 
        Count3 > 0 -> 
            InheritancePart3 is InheritanceTotal / 10,
            IndividualShare3 is InheritancePart3 / Count3,
            format('~w le da ~2f individualmente a sus ~d tios, primos y/o sobrinos con un total de ~2f~n', [X, IndividualShare3, Count3, InheritancePart3])
        ;
            format('~w no tiene tios ni primos ni sobrinos a los que le pueda heredar nada.~n', [X])
    ).

