-module(ex3).

-export([start/0, stop/0, run/1]).

% Consider the following non-deterministic pushdown automaton (PDA), where Z is the initial stack symbol and 
% represents the empty string:
% Write a concurrent Erlang program t


% --- State Logic (Unchanged, just removed stop() from q5) ---

q0() ->
    receive
        {S, [a | Xs], [z | T]} -> q1 ! {S, Xs, [a, z] ++ T}
    end,
    q0().

q1() ->
    receive
        {S, [a | Xs], [a | T]} ->
            q1 ! {S, Xs, [a, a] ++ T};
        {S, [b | Xs], [a | T]} ->
            q2 ! {S, Xs, T},       % Branch 1
            q3 ! {S, Xs, [a | T]}  % Branch 2
    end,
    q1().

q2() ->
    receive
        {S, [b | Xs], [a | T]} -> q2 ! {S, Xs, T};
        {S, Xs, [z | T]}       -> q5 ! {S, Xs, T} % Epsilon move
    end,
    q2().

q3() ->
    receive
        {S, [b | Xs], [a | T]} -> q4 ! {S, Xs, T}
    end,
    q3().

q4() ->
    receive
        {S, [b | Xs], [a | T]} -> q3 ! {S, Xs, [a | T]};
        {S, Xs, [z | T]}       -> q5 ! {S, Xs, T} % Epsilon move
    end,
    q4().

q5() ->
    receive
        % Accept only if input list is empty ([])
        {S, [], _Stack} -> 
            io:format("String ~p accepted!~n", [S])
    end,
    q5(). % Keep loop alive so we don't crash if another path arrives

% --- Management ---

start() ->
    register(q0, spawn(fun() -> q0() end)),
    register(q1, spawn(fun() -> q1() end)),
    register(q2, spawn(fun() -> q2() end)),
    register(q3, spawn(fun() -> q3() end)),
    register(q4, spawn(fun() -> q4() end)),
    register(q5, spawn(fun() -> q5() end)).

stop() ->
    catch unregister(q0),
    catch unregister(q1),
    catch unregister(q2),
    catch unregister(q3),
    catch unregister(q4),
    catch unregister(q5),
    ok.

% Helper to trigger the automaton
run(String) ->
    % Initial State: q0
    % Initial Stack: [z] (as per diagram Z)
    q0 ! {String, String, [z]}.