-module(ex3).

-export([dice_face/1, dice_roll/0]).

% Exercise 3, Erlang (11 pts)
% We want to simulate a 6-side dice, where each face is implemented by a process running the following procedure,
% where X represents the value of the face:

dice_face(X) ->
    timer:sleep(rand:uniform(40)),
    receive
        stop ->
            bye;
        PID ->
            PID ! X,
            dice_face(X)
    end.

% Write a procedure which simulates a dice: it first creates the processes for the faces, and waits for a value: the first
% one arriving in the message queue is the result of the roll. All the other messages must be purged from the queue,
% and the processes stopped.

dice_roll() ->
    Pids = [spawn(fun() -> dice_face(Val) end) || Val <- [1, 2, 3, 4, 5, 6]],
    % trigger all
    [P ! self() || P <- Pids],
    % first response wins
    Winner =
        receive
            V -> V
        end,
    % tell others to stop
    [P ! stop || P <- Pids],
    % drain any late responses
    flush(),
    Winner.

flush() ->
    receive
        _ -> flush()
    after 0 -> true
    end.
