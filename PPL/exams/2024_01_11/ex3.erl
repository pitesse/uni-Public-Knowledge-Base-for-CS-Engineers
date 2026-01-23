-module(ex3).

-export([manager/2]).

% Define a condition-var-manager process that receives a list of initial values and a list of the corresponding
% conditions (unary predicates), both of the same length, and spawns for each ordered pair of value and condition a
% process that updates its value only when the new value satisfies the condition.
% The manager can receive the following messages:
% - {update, F} where F is a unary function that must be applied to all the saved values to obtain the new values (only
%   if the corresponding condition holds);
% - print which makes each process print its current value;
% - stop which stops the manager and all its spawned processes.

manager(InitVals, InitConds) ->
    Parent = self(),
    Zipped = lists:zip(InitVals, InitConds),
    Pids = [spawn_link(fun() -> worker(Parent, V, C) end) || {V, C} <- Zipped],
    manloop(Parent, Zipped, Pids).

manloop(Parent, Zipped, Pids) ->
    receive
        {update, F} ->
            [P ! {update, F} || P <- Pids],
            manloop(Parent, Zipped, Pids);
        print ->
            [P ! print || P <- Pids],
            manloop(Parent, Zipped, Pids);
        stop ->
            [P ! stop || P <- Pids],
            ok
    end.

worker(Parent, Value, Condition) ->
    receive
        {update, F} ->
            NewVal = F(Value),
            case Condition(NewVal) of
                true -> worker(Parent, NewVal, Condition);
                false -> worker(Parent, Value, Condition)
            end;
        print ->
            io:format(
                "Worker ~p has value: ~p~n",
                [self(), Value]
            ),
            worker(Parent, Value, Condition);
        stop ->
            ok
    end.
