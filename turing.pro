%CALL TURING MACHINE WITH DISPLAYEXECUTETAPE


%same as the turing predicate but with a simpler-to-read output
displayExecuteTape(Q0, L0, H0, R0, Tape) :- 
    reverse(L0, L0R),
    turing(Q0, L0R, H0, R0, _, LF, HF, RF),
    reverse(LF, LFR),
    append(LFR, [HF|RF], Tape).

%actual turing machine predicate without the ease-of-use layer in front
%note that Left input is reversed (head of list is closest element to head of turing machine)
turing(qf, LF, HF, RF, qF, LF, HF, RF). %qf is exit condition, '-' is blankspace
turing(Q0, L0, H0, R0, QF, LF, HF, RF) :- 
    writeState(Q0, L0, H0, R0), %writes each intermediate state (optional)
    rule(Q0, H0, HNew, Direction, Q1), 
    tapeMovement(Direction, L0, HNew, R0, L1, H1, R1), !,
    turing(Q1, L1, H1, R1, QF, LF, HF, RF).

%tapeMovement(Dir , L0     , H0, R0     , LF     , HF, RF     ).
tapeMovement(stay , L      , H , R      , L      , H , R      ).
tapeMovement(right, L0     , H0, [HF|RF], [H0|L0], HF, RF     ).
tapeMovement(right, L0     , H0, []     , [H0|L0], - , []     ).
tapeMovement(left , [HF|L0], H0, R0     , L0     , HF, [H0|R0]).
tapeMovement(left , []     , H0, R0     , []     , - , [H0|R0]).

%code golf turing machine (just for the memes):
t(f,S,f-S).
t(S,E-I-T,P):-r(S,I,U,D,O),m(D,E,U,T,F),t(O,F,P).
m(r,L,H,R/F,L/H-F-R).
m(l,L/H,I,R,L-H-R/I).


% turingMachine(Q0, Left0, Head0, Right0, TapeOut) :- 
%     reverse(Left0, Left0R),
%     turing(Q0, Left0R, Head0, Right0, _, LeftF, HeadF, RightF),
%     reverse(LeftF, LeftFR),
%     append(LeftFR, [HeadF|RightF], TapeOut).
    
% turing(qf, LeftF, HeadF, RightF, qF, LeftF, HeadF, RightF). %qf is exit condition, '-' is blankspace
% turing(Q0, Left0, Head0, Right0, QF, LeftF, HeadF, RightF) :-
%     writeState(Q0, Left0, Head0, Right0),
%     rule(Q0, Head0, HeadNew, Direction, Q1), 

%     tapeMovement(Direction, Left0, HeadNew, Right0, Left1, Head1, Right1), !,
%     turing(Q1, Left1, Head1, Right1, QF, LeftF, HeadF, RightF).

% %tapeMovement(Dir , Left0        , Head0, Right0        , LeftF        , HeadF, RightF        ).
% tapeMovement(stay , Left         , Head , Right         , Left         , Head , Right         ).
% tapeMovement(right, Left0        , Head0, [HeadF|RightF], [Head0|Left0], HeadF, RightF        ).
% tapeMovement(right, Left0        , Head0, []            , [Head0|Left0], -    , []            ).
% tapeMovement(left , [HeadF|Left0], Head0, Right0        , Left0        , HeadF, [Head0|Right0]).
% tapeMovement(left , []           , Head0, Right0        , []           , -    , [Head0|Right0]).





%just for debugging:
writeState(Q, Left, Head, Right) :-
    reverse(Left, Rev),
    append(Rev, [Head|Right], TapeOut),
    %write(Rev), write(' '), write(Head), write(' '), writeln(Right).
    writeln(TapeOut),
    write(Q), writeln(':').

%rule(state0, readSym, writeSym, direction, stateF)



% rule(q0, 1    , 1, right, q0).
% rule(q0, -    , 1, stay , qf).

% turingMachine(q0, [], 1, [1, 1, 1], X).





% This example program checks if the input string is a binary palindrome.
% Input: a string of 0's and 1's, eg '1001001'


% Machine starts in state i.

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


