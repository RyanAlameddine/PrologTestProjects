/*
The dog ate the bone.
The big brown mouse chases a lazy cat.

sentence :
    nounphrase, verbphrase.
nounphrase :
    determiner, nounexpression.
nounphrase :
    nounexpression.
nounexpression :
    noun.
nounexpression :
    adjective, nounexpression.
verbphrase :
    verb, nounphrase.
determiner :
    the | a.
noun :
    dog | bone | mouse | cat.
verb :
    ate | chases.
adjective :
    big | brown | lazy.
*/

fancy :- false.



sentence(S) :-
    nounphrase(S-S1),
    verbphrase(S1-[]).

nounphrase(NP-X):-
    determiner(NP-S1),
    nounexpression(S1-X).
nounphrase(NP-X):-
    nounexpression(NP-X).

nounexpression(NE-X):-
    noun(NE-X).
nounexpression(NE-X):-
    adjective(NE-S1),
    nounexpression(S1-X).

verbphrase(VP-X):-
    verb(VP-S1),
    nounphrase(S1-X).

noun([dog|X]-X).
noun([cat|X]-X).
noun([mouse|X]-X).

verb([ate|X]-X).
verb([chases|X]-X).

adjective([big|X]-X).
adjective([brown|X]-X).
adjective([lazy|X]-X).

determiner([the|X]-X).
determiner([a|X]-X).