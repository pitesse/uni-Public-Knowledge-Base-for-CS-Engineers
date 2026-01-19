-module(ex3).

-export([deepmaprev/2, deepmaprevpar/2, worker/3]).

% Exercise 3, Erlang (11 pts)
% 1) Write a function: deepmaprev(F, List), that applies a function F to every non-list element in a possibly deep list,
% and reverses the list structure at every level.
% Example:
% > deepmaprev(fun(X) -> X+1 end, [[0,1],2,3,[4,[5]]]).
% [[[6],5],4,3,[2,1]]
% 2) Write a parallel version, that behaves exactly like deepmaprev/2 but spawns a separate process to handle each
% top-level element in the input list, then collects and assembles the results in the correct order.

deepmaprev(F, List) when is_list(List) ->
    lists:reverse([deepmaprev(F, X) || X <- List]);
deepmaprev(F, X) ->
    F(X).

deepmaprevpar(F, List) ->
    Parent = self(),
    Childrens = [spawn(?MODULE, worker, [Parent, F, Toplevel]) || Toplevel <- List],
    Result = [
        receive
            {P, V} -> V
        end
     || P <- Childrens
    ],
    lists:reverse(Result).

worker(Parent, F, Elem) ->
    Result = deepmaprev(F, Elem),
    Parent ! {self(), Result}.