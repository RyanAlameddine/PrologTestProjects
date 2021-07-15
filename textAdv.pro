
command_loop:-  
    prompt(_, ''),
    repeat,
    write('Enter command (end to exit): '),
    read(X),
    write(X), nl,
    X = end.

do(goto(X))  :- goto(X),!.
do(go(X))    :- goto(X),!.
do(inventory):- inventory,!.
do(look)     :- look,!.
do(take(X))  :- take(X), !.
do(end).
do(_) :- write('Invalid command').



%language

% [go, to, the, office] -> [goto, office]
%command(OutputList, InputList).
command([V], InList):- verb(V, InList-[]).
command([V,O], InList) :-
    verb(Object_Type, V, InList-S1),
    object(Object_Type, O, S1-[]).

verb(look, [look|X]-X).
verb(look, [look,around|X]-X).
verb(list_possessions, [inventory|X]-X).
verb(end, [end|X]-X).
verb(end, [quit|X]-X).
verb(end, [good,bye|X]-X).

verb(place, goto, [go,to|X]-X).
verb(place, goto, [go|X]-X).
verb(place, goto, [move,to|X]-X).
verb(place, goto, [X|Y]-[X|Y]):- room(X).
verb(place, goto, [dining,room|Y]-[dining,room|Y]).

verb(thing, take, [take|X]-X).
verb(thing, drop, [drop|X]-X).
verb(thing, drop, [put|X]-X).
verb(thing, turn_on, [turn,on|X]-X).

object(Type, N, S1-S3) :-
    article(S1-S2),
    noun(Type, N, S2-S3).
object(Type, N, S1-S2) :-
    noun(Type, N, S1-S2).

article([the|X]-X).
article([a|X]-X).
article([an|X]-X).

noun(place, R, [R|X]-X):- room(R).
noun(place, 'dining room', [dining,room|X]-X).

noun(thing, T, [T|X]-X):- location(T,_).
noun(thing, T, [T|X]-X):- have(T).
noun(thing, 'washing machine', [washing,machine|X]-X).

noun(thing, flashlight, [light|X]-X):- have(flashlight).
noun(thing, light,      [light|X]-X).