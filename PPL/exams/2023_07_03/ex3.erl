-module(ex3).

-export([deeprev/1, deeprevp/1]).

% Exercise 3, Erlang (11 pts)
% 1. Define a “deep reverse” function, which takes a “deep” list, i.e. a list containing possibly lists of any
% depths, and returns its reverse.
% E.g. deeprev([1,2,[3,[4,5]],[6]]) is [[6],[[5,4],3],2,1].
% 2. Define a parallel version of the previous function.

deeprev(X) when not is_list(X) ->
    X;
deeprev(L) ->
    lists:foldl(fun(X, Acc) -> [deeprev(X) | Acc] end, [], L).

deeprevp(X) when not is_list(X) -> 
    X;
deeprevp(L) ->
    Parent = self(),
    Pids = [spawn(fun() -> Parent ! {self(), deeprevp(X)} end) || X <- L],
    DeepMapped = [receive {Pid, Result} -> Result end || Pid <- Pids],
    lists:reverse(DeepMapped).
