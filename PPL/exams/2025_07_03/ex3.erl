-module(ex3).

-export([filtermap/4, worker_logic/4]).

% Exercise 3, Erlang
% Define a parallel filter and map operation, which has,
% together with the function for the map, two predicates
% (respectively called pre-condition and post-condition) for filtering the list
% values: the first one filters the values to
% be processed (i.e. it does not map the values that falsify the pre-condition),
% while the second one is used to filter the
% results.
%
% E.g. filtermap(
% fun (X) -> % pre-condition
%     X > 3.
% end,
% fun (X) -> X*X;
% % map operation
% end,
% fun (X) -> % post-condition
%     X < 20.
% end,
% [1, 2, 3, 4, 5]).
% should return [16]

%% Worker process: computes and sends result back to Parent
worker_logic(ParentPid, MapFunc, PostPred, Item) ->
    MappedValue = MapFunc(Item),
    case PostPred(MappedValue) of
        true -> ParentPid ! {self(), MappedValue};
        false -> ParentPid ! {self(), none}
    end.

%% Helper to retrieve result for a specific Worker (or skip)
collect_result(none) ->
    none;
collect_result(Pid) ->
    receive
        {Pid, Result} -> Result
    end.

%% Main function
filtermap(PrePred, MapFunc, PostPred, InputList) ->
    %% 1. Spawn workers only for items passing PrePred
    WorkerPidsOrSkips = [
        case PrePred(X) of
            true -> spawn(?MODULE, worker_logic, [self(), MapFunc, PostPred, X]);
            false -> none
        end
     || X <- InputList
    ],

    %% 2. Collect results in order (blocking wait)
    RawResults = lists:map(fun collect_result/1, WorkerPidsOrSkips),

    %% 3. Filter out 'none' values
    lists:filter(fun(Val) -> Val =/= none end, RawResults).

% filtermap(List, Func, Pred1, Pred2) ->
%     Parent = self(),
%     Filter = spawn(?MODULE, filter, [Parent, List, Pred1]),
%     receive
%         {Pid1, ok_filter, Filtered} ->
%             Map = spawn(?MODULE, map, [Parent, Filtered, Func]),
%             receive
%                 {Pid2, ok_map, Mapped} ->
%                     Filter2 = spawn(?MODULE, filter, [Parent, Mapped, Pred2]),
%                     receive
%                         {Pid3, ok_filter, Result} -> Result
%                     end
%             end
%     end.

% filter(Parent, List, Pred) ->
%     Filtered = lists:filter(Pred, List),
%     Parent ! {self(), ok_filter, Filtered}.

% map(Parent, List, Func) ->
%     Mapped = lists:map(Func, List),
%     Parent ! {self(), ok_map, Mapped}.
