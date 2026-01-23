-module(ex3).

-export([getres/1]).

% Exercise 3, Erlang (11 pts)
% Consider a list L of tasks, where each task is encoded as a function having only one parameter: a PID P. When a
% task is called, it runs some operations and then sends back the results to P, in this form: {result, <Task_PID>,
% <Result_value>}; a task could also fail for some errors.
% Define a server which takes L and runs in parallel all the tasks in it, returning the list of the results (the order is not
% important). Note: in case of failure, every task should be restarted only once; if it fails twice, its result should be
% represented with the atom bug.
% Utilities: you can use from the standard libraries the following functions: maps:from_list(<List of {Key, Value}>),
% which takes a list of pairs and builds the corresponding map, and maps:values(<Map>), which is its inverse.

getres(Fs) ->
    Self = self(),
    process_flag(trap_exit, true),
    Pids = maps:from_list([{spawn_link(fun() -> F(Self) end), {F, wait}} || F <- Fs]),
    getres_loop(Pids, length(Fs)).

getres_loop(Pids, 0) ->
    [R || {done, R} <- maps:values(Pids)];
getres_loop(Pids, Waiting) ->
    receive
        {result, Pid, R} ->
            getres_loop(Pids#{Pid := {done, R}}, Waiting - 1);
        {'EXIT', Pid, Reason} when Reason /= normal ->
            #{Pid := {F, Status}} = Pids,
            Self = self(),
            case Status of
                restart ->
                    getres_loop(Pids#{Pid := {done, bug}}, Waiting - 1);
                _ ->
                    NewPid = spawn_link(fun() -> F(Self) end),
                    getres_loop(Pids#{NewPid => {F, restart}}, Waiting)
            end
    end.
