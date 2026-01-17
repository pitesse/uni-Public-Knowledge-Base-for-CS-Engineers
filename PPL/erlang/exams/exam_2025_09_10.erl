-module(exam_2025_09_10).
-compile(export_all).

% receives a list of {Fun, Params}
% 
% 
% 
% 
start(FunParamsList) ->
    Parent = self(),
    [spawn(?MODULE, supervisor, [Parent, Fun, Params, 3]) || {Fun, Params} <- FunParamsList],
    wait_all(length(FunParamsList)),
    io:format("All supervisors have finished.~n").

wait_all(0) -> ok;
wait_all(N) ->
    receive
        _ -> wait_all(N - 1)
    end.

supervisor(Parent, Fun, Params, 0) ->
    io:format("Supervisor: No more retries left for ~p with params ~p.~n", [Fun, Params]),
    Parent ! ok;
supervisor(Parent, Fun, Params, Retry) ->
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, worker, [Fun, Params]),
    receive
        {ok, Pid, Result} ->
            io:format("Print from supervisor: Worker ~p finished successfully with result ~p.~n", [Pid, Result]),
            Parent ! ok;
        {'EXIT', Pid, Reason} ->
            io:format("Print from supervisor: Worker ~p crashed with reason ~p. Retries left: ~p.~n", [Pid, Reason, Retry - 1]),
            supervisor(Parent, Fun, Params, Retry - 1)
    end.

worker(SupervisorPid, Fun, Params) ->
    Result = apply(?MODULE, Fun, Params),
    SupervisorPid ! {ok, self(), Result}.


