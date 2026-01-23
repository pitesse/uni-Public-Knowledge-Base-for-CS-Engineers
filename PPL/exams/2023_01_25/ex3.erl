-module(ex3).

-export([start/0, read_string/1]).

% Consider the following non-deterministic finite state automaton (FSA):
% a b
% q0
% q1
% b
% b b c
% q2 q3 q4
% Write a concurrent Erlang program that simulates the previous FSA, where each state is implemented as a process.

q0() ->
    receive
        {S, [b | Xs]} ->
            q1 ! {S, Xs},
            q2 ! {S, Xs};
        {S, [a | Xs]} ->
            q0 ! {S, Xs}
    end,
    q0().

q1() ->
    receive
        {S, [b | Xs]} -> q0 ! {S, Xs}
    end,
    q1().

q2() ->
    receive
        {S, [b | Xs]} -> q3 ! {S, Xs}
    end,
    q2().

q3() ->
    receive
        {S, [c | Xs]} -> q4 ! {S, Xs}
    end,
    q3().

q4() ->
    receive
        {S, []} -> io:format("~w accepted~n", [S])
    end,
    q4().

start() ->
    % to avoid exporting qs
    register(q0, spawn(fun() -> q0() end)),
    register(q1, spawn(fun() -> q1() end)),
    register(q2, spawn(fun() -> q2() end)),
    register(q3, spawn(fun() -> q3() end)),
    register(q4, spawn(fun() -> q4() end)).

read_string(S) ->
    q0 ! {S, S},
    ok.
