-module(exam_2025_01_20).
-compile(export_all).

dice_face(X) ->
    timer:sleep(rand:uniform(40)),
    receive
        stop -> bye;
        PID ->
            PID ! X,
            dice_face(X)
    end.

% procedure to simulate a die
% create the processes for the faces
% get the value from the faces
% first one to send message to die procedure is the result
% purge queue and terminate processes
% return result

roll_die() ->
    Pids = lists:map(
        fun(X) -> 
            spawn(fun() -> dice_face(X) end) 
        end,
        [1,2,3,4,5,6]),
    lists:map(fun(Pid) -> Pid ! self() end, Pids),
    receive 
        V -> ok
    end,
    flush(),
    terminate_procs(Pids),
    V.

flush() ->
    receive
        _ -> flush()
    after 0 -> ok
    end.

terminate_procs(Pids) -> 
    lists:map(fun(Pid) -> Pid ! stop end, Pids).

