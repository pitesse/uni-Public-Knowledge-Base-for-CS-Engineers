-module(ex3).

-export([tripart/6]).

% Exercise 3, Erlang (10 pts)
% Define a program tripart which takes a list, two values x and y, with x < y, and three functions, taking
% one argument which must be a list.
% • tripart first partitions the list in three sublists, one containing values that are less than both x and
%   y, one containing values v such that x ≤ v ≤ y, and one containing values that are greater than both
%   x and y.
% • Three processes are then spawned in parallel, running the three given functions and passing the
%   three sublists in order (i.e. the first function must work on the first sublist and so on).
% • Lastly, the program must wait the termination of the three processes in the spawning order,
%   assuming that each one will return the pair {P, V}, where P is its PID and V the resulting value.
% • tripart must return the three resulting values in a list, with the resulting values in the same order
%   as the corresponding sublists.

% 1. PARTITION: One-pass, Order-preserving
% We use foldr. Since we process from right-to-left, simple consing ([H|T])
% keeps the original order. No reverse needed!
partition(L, X, Y) ->
    lists:foldr(
        fun(E, {Low, Mid, High}) ->
            if
                E < X, E < Y -> {[E | Low], Mid, High};
                E > X, E > Y -> {Low, Mid, [E | High]};
                % The middle case
                true -> {Low, [E | Mid], High}
            end
        end,
        {[], [], []},
        L
    ).

% 2. WORKER WRAPPER
% Executes the function F on Data and sends the result to Parent
worker(Parent, F, Data) ->
    Val = F(Data),
    Parent ! {self(), Val}.

% 3. MAIN FUNCTION
tripart(L, X, Y, F1, F2, F3) ->
    % Get the 3 lists
    {L1, L2, L3} = partition(L, X, Y),

    % Spawn processes using a lambda wrapper
    % We capture 'self()' to ensure they reply to US.
    Parent = self(),
    P1 = spawn(fun() -> worker(Parent, F1, L1) end),
    P2 = spawn(fun() -> worker(Parent, F2, L2) end),
    P3 = spawn(fun() -> worker(Parent, F3, L3) end),

    % Collect results IN ORDER
    % We hardcode the receive order to P1 -> P2 -> P3
    V1 =
        receive
            {P1, Res1} -> Res1
        end,
    V2 =
        receive
            {P2, Res2} -> Res2
        end,
    V3 =
        receive
            {P3, Res3} -> Res3
        end,

    [V1, V2, V3].
