-module(ex3).

% Exercise 3, Erlang (8 pts)
% Define a function which takes two list of PIDs [x1, x2, ...], [y1, y2, ...], having the same length, and a
% function f, and creates a different "broker" process for managing the interaction between each pair of
% processes xi and yi.
% At start, the broker process i must send its PID to xi and yi with a message {broker, PID}. Then, the
% broker i will receive messages {from, PID, data, D} from xi or yi, and it must send to the other one an
% analogous message, but with the broker PID and data D modified by applying f to it.
% A special stop message can be sent to a broker i, that will end its activity sending the same message to xi
% and yi.

start_brokers(Xs, Ys, F) ->
    lists:zipwith(
        fun(X, Y) ->
            spawn(?MODULE, init_broker, [X, Y, F])
        end,
        Xs,
        Ys
    ).

init_broker(X, Y, F) ->
    X ! {broker, self()},
    Y ! {broker, self()},
    broker_loop(X, Y, F).

broker_loop(X, Y, F) ->
    receive
        {from, X, data, D} ->
            Y ! {from, self(), data, F(D)},
            broker_loop(X, Y, F);
        % From Y -> Send to X
        {from, Y, data, D} ->
            X ! {from, self(), data, F(D)},
            broker_loop(X, Y, F);
        stop ->
            X ! stop,
            Y ! stop,
            ok
    end.
