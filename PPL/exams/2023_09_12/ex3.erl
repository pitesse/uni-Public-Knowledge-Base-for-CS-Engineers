-module(ex3).

% Only export the creator functions
-export([btrees/1, incbtrees/1]).

% Exercise 3, Erlang (11 pts)
% Consider the infinite list of binary trees of Exercise 2: instead of infinite lists, we want to create processes which
% return the current element of the "virtual infinite list" with the message next, and terminate with the message stop.
% 1. Define a function btrees to create a process corresponding to the infinite tree of Exercise 2.1.
% 2. Define a function incbtrees to create a process corresponding to the infinite tree of Exercise 2.2.
% Notes: for security reasons, processes must only answer to their creating process; to define trees, you can use
% suitable tuples with atoms as customary in Erlang (e.g. {branch, {leaf, 1}, {leaf, 1}}).

inctree({leaf, X}) -> {leaf, X + 1};
inctree({branch, L, R}) -> {branch, inctree(L), inctree(R)}.

btrees(Val) ->
    Creator = self(),
    spawn(fun() ->
        btrees_loop(Creator, {leaf, Val})
    end).

btrees_loop(Creator, CurrentTree) ->
    receive
        {Creator, next} ->
            Creator ! CurrentTree,
            NextTree = {branch, CurrentTree, CurrentTree},
            btrees_loop(Creator, NextTree);
        {Creator, stop} ->
            ok
    end.

incbtrees(Pid) ->
    spawn(fun() ->
        incbtrees_loop(Pid, {leaf, 1})
    end).

incbtrees_loop(Creator, CurrentTree) ->
    receive
        {Creator, next} ->
            Creator ! CurrentTree,
            Incremented = inctree(CurrentTree),
            NextTree = {branch, Incremented, Incremented},
            incbtrees_loop(Creator, NextTree);
        {Creator, stop} ->
            ok
    end.
