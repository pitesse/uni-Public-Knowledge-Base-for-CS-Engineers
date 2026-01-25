-module(ex3).

-export([ master/2]).

% Exercise 3, Erlang (10 pts)
% Consider a main process which takes two lists: one of function names, and one of lists of parameters (the
% first element of with contains the parameters for the first function, and so forth). For each function, the
% main process must spawn a worker process, passing to it the corresponding argument list. If one of the
% workers fails for some reason, the main process must create another worker running the same function.
% The main process ends when all the workers are done.

master(Functions, Arguments) ->
    process_flag(trap_exit, true),
    Pairs = lists:zip(Functions, Arguments),
    WorkerList = [
        {spawn_link(?MODULE, F, D), {F, D}} 
        || {F, D} <- Pairs
    ],
    % convert to Map: efficient lookups
    Workers = maps:from_list(WorkerList),
    master_loop(Workers, length(Functions)).

master_loop(Workers, 0) -> ok; % count reaches 0
master_loop(Workers, Count) ->
    receive
        {'EXIT', _, normal} ->
            master_loop(Workers, Count - 1);
            
        {'EXIT', Child, _Reason} ->
            #{Child := {F, D}} = Workers,
            NewPid = spawn_link(?MODULE, F, D),
            % remove old PID, Add new PID
            NewWorkers = maps:put(NewPid, {F, D}, maps:remove(Child, Workers)),
            
            master_loop(NewWorkers, Count)
    end.