-module(ex3).

-export([main/1, sup/4, worker/3]).

% Consider a main process which takes a list of tuples of the form {Fun, Params}, where:
% • Fun is a function (an atom bound in the current module).
% • Params is the list of arguments for that function.
% The main process must:
% 1. Spawn a supervisor process for each {Fun, Params} tuple.
% 2. Each supervisor process must spawn a worker running Fun(Params).
% 3. If the worker dies for any reason, the supervisor must restart it up to 3 times. If it fails 3 times, the
% 4. supervisor stops.
% The main process finishes only when all supervisors terminate.

main(TaskList) ->
    Parent = self(),
    _Supervisors = [spawn(?MODULE, sup, [Parent, Fun, Args, 3]) || {Fun, Args} <- TaskList],
    wait_all(length(TaskList)).

wait_all(0) ->
    ok;
wait_all(N) ->
    receive
        {done, _} -> wait_all(N - 1)
    end.

sup(MainProc, _Fun, _Args, 0) ->
    MainProc ! {done, self()};
sup(MainProc, Fun, Args, N) ->
    Pid = spawn_link(?MODULE, worker, [self(), Fun, Args]),
    receive
        %% Success path (worker sends its result)
        {ok, Pid, Result} ->
            io:format(
                "Worker ~p(~p) finished successfully: ~p~n",
                [Fun, Args, Result]
            ),
            MainProc ! {done, self()};
        %% If the worker exits normally before/after {ok,...} arrives
        {'EXIT', Pid, normal} ->
            io:format("Worker ~p(~p) finished successfully.~n", [Fun, Args]),
            MainProc ! {done, self()};
        %% Crash path: restart
        {'EXIT', Pid, Reason} ->
            io:format(
                "Worker ~p(~p) crashed with ~p. Restarting... (~p left)~n",
                [Fun, Args, Reason, N - 1]
            ),
            sup(MainProc, Fun, Args, N - 1)
    end.

worker(Supervisor, Fun, Args) ->
    Result = apply(?MODULE, Fun, Args),
    Supervisor ! {ok, self(), Result}.
