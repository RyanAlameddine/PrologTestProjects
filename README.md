# PrologTestProjects

My experimentation with this logic programming language associated based in first-order and formal logic.

As part of my experimentation, I have written a turing machine logicbase in the turing.pro file:

```prolog
turingMachine(Q0, L0, H0, R0, Tape) :- 
    reverse(L0, L0R),
    turing(Q0, L0R, H0, R0, _, LF, HF, RF),
    reverse(LF, LFR),
    append(LFR, [HF|RF], Tape).
    
turing(qf, LF, HF, RF, qF, LF, HF, RF). %qf is exit condition, '-' is blankspace
turing(Q0, L0, H0, R0, QF, LF, HF, RF) :- 
    writeState(Q0, L0, H0, R0), %writes each intermediate state (optional)
    rule(Q0, H0, HNew, Direction, Q1), 
    tapeMovement(Direction, L0, HNew, R0, L1, H1, R1), !,
    turing(Q1, L1, H1, R1, QF, LF, HF, RF).
    
tapeMovement(stay , L      , H , R      , L      , H , R      ).
tapeMovement(right, L0     , H0, [HF|RF], [H0|L0], HF, RF     ).
tapeMovement(right, L0     , H0, []     , [H0|L0], - , []     ).
tapeMovement(left , [HF|L0], H0, R0     , L0     , HF, [H0|R0]).
tapeMovement(left , []     , H0, R0     , []     , - , [H0|R0]).
```
*Note: the dash character '-' represents an empty slot on the tape*.


The rules of my turing machine state transitions are defined as predicates, either explicitely stated or dynamically asserted at runtime. They are defined as follows:
```prolog
rule(current state, symbol to read, symbol to write, direction to move on tape, final state)
```

For example, a binary palindrome checker:

```prolog
% State i: read the leftmost symbol
rule(i, 0, -, right, o1    ).
rule(i, 1, -, right, i1    ).
rule(i, -, -, stay , accept).     % Empty input

% State o1, i1: find the rightmost symbol
rule(o1, -, -, left , o2).
rule(o1, X, X, right, o1).

rule(i1, -, -, left , i2).
rule(i1, X, X, right, i1).

% State o2, i2: check if the rightmost symbol matches the most recently read left-hand symbol
rule(o2, 0, -, left, f3    ).
rule(o2, -, -, stay, accept).
rule(o2, X, X, stay, reject).

rule(i2, 1, -, left, f3    ).
rule(i2, -, -, stay, accept).
rule(i2, X, X, stay, reject).

% State f3, f4: return to left end of remaining input
rule(f3, -, -, stay  , accept).
rule(f3, X, X, left , f4    ).
rule(f4, -, -, right, i     ).  % Back to the beginning
rule(f4, X, X, left , f4    ).

rule(accept , _, :  , right, accept2).
rule(accept2, _, ')', stay , qf     ).

rule(reject , -, :  , right, reject2).
rule(reject , _, -  , left , reject ).
rule(reject2, _, '(', stay , qf     ).
```
