-module(ex3).

% Exercise 3, Erlang (12 pts)
% Define a parallel lexer, which takes as input a string x and a chunk size n, and translates all the words in
% the strings to atoms, sending to each worker a chunk of x of size n (the last chunk could be shorter than
% n). You can assume that the words in the string are separated only by space characters (they can be more
% than one - the ASCII code for ' ' is 32); it is ok also to split words, if they overlap on different chunks.
% E.g.
% plex("this is a nice test", 6) returns [[this,i],[s,a,ni],[ce,te],[st]]
% For you convenience, you can use the library functions:
% • lists:sublist(List, Position, Size) which returns the sublist of List of size Size from
% position Position (starting at 1);
% • list_to_atom(Word) which translates the string Word into an atom.

-export([plex/2, worker_task/2]).
% We export worker_task so 'spawn' can find it

% 1. HELPER: Manual Lexer (No string:tokens)

% Entry point
lex(String) ->
    lex(String, []).

% Case 1: Space detected (ASCII 32)
% If we have a built-up word (Acc), finish it. If Acc is empty, just skip space.
lex([32 | Rest], []) ->
    % Skip multiple spaces
    lex(Rest, []);
lex([32 | Rest], Acc) ->
    % Finish word
    Atom = list_to_atom(lists:reverse(Acc)),
    [Atom | lex(Rest, [])];
% Case 2: Normal Character
% Add character to Accumulator. We prepend [Char | Acc] for O(1) speed.
lex([Char | Rest], Acc) ->
    lex(Rest, [Char | Acc]);
% Case 3: End of String
lex([], []) ->
    [];
lex([], Acc) ->
    % Finish the last word
    [list_to_atom(lists:reverse(Acc))].

% 2. HELPER: Splitter (O(N) Complexity)

chunk_list([], _) ->
    [];
chunk_list(List, Size) ->
    Len = length(List),
    if
        Len =< Size ->
            [List];
        true ->
            {Head, Tail} = lists:split(Size, List),
            [Head | chunk_list(Tail, Size)]
    end.

% 3. MAIN LOGIC

% The code running inside each process
worker_task(Parent, String) ->
    Result = lex(String),
    Parent ! {self(), Result}.

plex(String, N) ->
    % 1. Split the string
    Chunks = chunk_list(String, N),

    % 2. Spawn processes (One for each chunk)
    Pids = [spawn(?MODULE, worker_task, [self(), Chunk]) || Chunk <- Chunks],

    % 3. Collect results (Preserving Order)
    % We match specifically on P to ensure we get results
    % in the same order we spawned them.
    [
        receive
            {P, Result} -> Result
        end
     || P <- Pids
    ].
