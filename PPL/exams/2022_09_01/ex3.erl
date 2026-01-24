-module(ex3).

% Exercise 3, Erlang (12 pts)
% We want to implement a parallel foldl, parfold(F, L, N), where the binary operator F is associative, and N
% is the number of parallel processes in which to split the evaluation of the fold. Being F associative,
% parfold can evaluate foldl on the N partitions of L in parallel. Notice that there is no starting (or
% accumulating) value, differently from the standard foldl.
% You may use the following libray functions:
% lists:foldl(<function>, <starting value>, <list>)
% lists:sublist(<list>, <init>, <length>), which returns the sublist of <list> starting at position
% <init> and of length <length>, where the first position of a list is 1.

-export([parfold/3, dofold/3]). % Export dofold so spawn can see it

partition(L, N) ->
    Len = length(L),
    ChunkSize = if Len < N -> 1; true -> Len div N end,
    split_list(L, N, ChunkSize).

split_list([], _, _) -> []; % Handle empty rest
split_list(L, 1, _) -> [L]; % Last processor takes the rest
split_list(L, N, Size) ->
    case length(L) >= Size of
        true ->
            {Chunk, Rest} = lists:split(Size, L),
            [Chunk | split_list(Rest, N - 1, Size)];
        false ->
            [L] % Rest of list is smaller than Chunk Size
    end.

parfold(_, [], _) -> []; 
parfold(F, L, N) ->
    Chunks = partition(L, N),
    ValidChunks = [C || C <- Chunks, C /= []],
    W = [spawn(?MODULE, dofold, [self(), F, C]) || C <- ValidChunks],
    [R | Rs] = [
        receive
            {Pid, Res} -> Res
        end
     || Pid <- W
    ],
    
    % Final fold on the partial results
    lists:foldl(F, R, Rs).

dofold(Parent, F, [X | Xs]) ->
    % No initial value? Use X as start, fold over Xs
    Parent ! {self(), lists:foldl(F, X, Xs)}.
