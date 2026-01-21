-module(ex3).

-export([check_pref/2, worker/2]).

% Exercise 3, Erlang (11 pts)
% Consider the set of all non-null prefixes of a list (e.g. for [1, 2, 3] the prefixes are {[1], [1, 2], [1, 2, 3]}).
% Write a function check_pref which takes two lists, T and L, then creates a set of processes P for each prefix of the
% list L – such processes must receive a list and control if it matches the one associated to the process: if yes, it must
% return the atom yes, otherwise the atom no. Then, check_pref uses the processes in P to check if T is a prefix of L.

check_pref(T, L) ->
    Parent = self(),
    Prefixes = [lists:sublist(L, N) || N <- lists:seq(1, length(L))],
    Pids = [spawn(fun() -> worker(Parent, PrefixL) end) || PrefixL <- Prefixes],
    [P ! T || P <- Pids],
    lists:member(yes, [
        receive
            X -> X
        end
     || _ <- Pids
    ]).

worker(Parent, Prefix) ->
    receive
        Prefix -> Parent ! yes;
        _ -> Parent ! no
    end,
    worker(Parent, Prefix).
