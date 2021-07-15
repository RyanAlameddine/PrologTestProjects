main :-
    schedule([1-2, 1-3, 2-1, 2-3, 3-1, 3-2], [], SCHEDULE),
    write(SCHEDULE).

% schedule([], SCHEDULE, SCHEDULE).
% schedule(GAMES, PARTIAL_SCHEDULE, SCHEDULE) :-
%     pick(GAMES, DAYS_GAMES, GAMES_LEFT),
%     test(DAYS_GAMES, PARTIAL_SCHEDULE),
%     schedule(GAMES_LEFT, [DAYS_GAMES|PARTIAL_SCHEDULE], SCHEDULE).

/*
There are some constraints that are inherent in a round robin scheduler.  
One is that each team play each other team, usually twice.  
In the first half of the season each team plays each other once, and in the second half they repeat with home and away teams reversed.  
Another is that no team can be playing two games at the same time.  
And another is that the schedule should be as compact as possible, so if there are eight teams, then there can be four games played each day.
*/

/*
One way to guarantee the right number of games for each day is to have the loop that picks games for each day programmed with this information.  
Another way is to provide a template for a day's games, in which the teams are represented by variables.  
This is the approach taken in the scheduling program.
*/
%day: day(N, [T1-T2, T3-T4, T5-T6, T7-T8])

/*
The next constraint, that each team play each other once in the first half and once in the second half, leads to the first efficiency in the program.  
Because the first and second halves almost mirror each other, but have a slight difference, separate predicates are implemented for filling in each half.
*/

schedule(SCHEDULE) :-
    games(GAMES),
    first_half(GAMES, [], SCHEDULE_1, [], GAMES_2),
    second_half(GAMES_2, SCHEDULE_1, SCHEDULE).

get_games([], _).
get_games([AWAY-HOME|GAMES], PICK_LIST) :-
  deal(AWAY-HOME, PICK_LIST, PICKS_LEFT),
  clean(AWAY-HOME, PICKS_LEFT, CLEANED_PICKS),
  get_games(GAMES, CLEANED_PICKS).