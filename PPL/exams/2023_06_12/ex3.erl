-module(ex3).

-export([mergesortp/1, mergesort/1]).

% Exercise 3, Erlang (11 pts)
% Consider the following implementation of mergesort and write a parallel version of it.
% mergesort([L]) -> [L];
% mergesort(L) ->
% {L1, L2} = lists:split(length(L) div 2, L),
% merge(mergesort(L1), mergesort(L2)).
% merge(L1, L2) -> merge(L1, L2, []).
% merge([], L2, A) -> A ++ L2;
% merge(L1, [], A) -> A ++ L1;
% merge([H1|T1], [H2|T2], A) when H2 >= H1 -> merge(T1, [H2|T2], A ++ [H1]);
% merge([H1|T1], [H2|T2], A) when H1 > H2 -> merge([H1|T1], T2, A ++ [H2]).

mergesortp(L) ->
    Me = self(),
    msp(Me, L),
    receive
        {Me, R} -> R
    end.

msp(Pid, [L]) ->
    Pid ! {self(), [L]};
msp(Pid, L) ->
    {L1, L2} = lists:split(length(L) div 2, L),
    Me = self(),
    Pid1 = spawn(fun() -> msp(Me, L1) end),
    Pid2 = spawn(fun() -> msp(Me, L2) end),
    receive
        {Pid1, Sorted1} ->
            receive
                {Pid2, Sorted2} ->
                    Pid ! {self(), merge(Sorted1, Sorted2)}
            end
    end.

mergesort([L]) ->
    [L];
mergesort(L) ->
    {L1, L2} = lists:split(length(L) div 2, L),
    merge(mergesort(L1), mergesort(L2)).

merge(L1, L2) -> merge(L1, L2, []).
merge([], L2, A) -> A ++ L2;
merge(L1, [], A) -> A ++ L1;
merge([H1 | T1], [H2 | T2], A) when H2 >= H1 -> merge(T1, [H2 | T2], A ++ [H1]);
merge([H1 | T1], [H2 | T2], A) when H1 > H2 -> merge([H1 | T1], T2, A ++ [H2]).
