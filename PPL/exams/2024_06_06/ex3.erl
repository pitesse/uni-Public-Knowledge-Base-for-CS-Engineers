-module(ex3).

-export([parallel_apply/3, worker/2]).

% Exercise 3, Erlang (11 pts)
% Pino wants to create a Erlang program which takes two lists of data [x1, x2, ..], [y1, y2, ...] and a list of binary
% functions [f1, f2, ...], and evaluates these functions in parallel, passing them the respective parameters, to obtain
% [f1(x1, y1), f2(x2, y2), …].
% To this end, Pino tries to use ChatGPT, obtaining the result shown in the next page.

% -export([parallel_apply/3, worker/2, collector/2]).
% % Entry function to start the parallel processing
% parallel_apply(List1, List2, FunList) ->
%     CollectorPid = spawn(fun() -> collector([], length(FunList)) end),
%     spawn_workers(List1, List2, FunList, CollectorPid),
%     receive
%         {results, Results} -> Results
%     end.
% % Spawn worker processes for each element pair and function
% spawn_workers([H1 | T1], [H2 | T2], [F | Fs], CollectorPid) ->
%     spawn(fun() -> worker({F, H1, H2}, CollectorPid) end),
%     spawn_workers(T1, T2, Fs, CollectorPid);
% spawn_workers([], [], [], _) ->
%     done.
% % Worker process to apply function to pair of elements
% worker({F, A, B}, CollectorPid) ->
%     Result = F(A, B),
%     CollectorPid ! {result, Result}.
% % Collector process to gather all results
% collector(Results, 0) ->
%     % Send the final results back to the parent process
%     ParentPid = self(),
%     ParentPid ! {results, lists:reverse(Results)};
% collector(Results, N) ->
%     receive
%         {result, Result} ->
%             collector([Result | Results], N - 1)
%     end.

% there are many errors: e.g. the collector get its PID instead of the one of its parent; the collector also assumes that the
% results from the worker will arrive in the correct order, so it doesn’t keep PIDs for the workers.

parallel_apply(List1, List2, FunList) ->
    W = lists:map(
        fun(X) -> spawn(?MODULE, worker, [X, self()]) end,
        lists:zip3(List1, List2, FunList)
    ),
    lists:map(
        fun(P) ->
            receive
                {P, V} -> V
            end
        end,
        W
    ).

worker({A, B, F}, CollectorPid) ->
    CollectorPid ! {self(), F(A, B)}.
