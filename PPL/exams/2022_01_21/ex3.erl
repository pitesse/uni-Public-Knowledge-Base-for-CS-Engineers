-module(ex3).

% Exercise 3, Erlang (12 pts)
% Create a distributed hash table with separate chaining. The hash table will consist of an agent for each
% bucket, and a master agent that stores the buckets’ PIDs and acts as a middleware between them and the
% user. Actual key/value pairs are stored into the bucket agents.
% The middleware agent must be implemented by a function called hashtable_spawn that takes as its
% arguments (1) the hash function and (2) the number of buckets. When executed, hashtable_spawn
% spawns the bucket nodes, and starts listening for queries from the user. Such queries can be of two kinds:
% • Insert: {insert, Key, Value} inserts a new element into the hash table, or updates it if an
% element with the same key exists;
% • Lookup: {lookup, Key, RecipientPid} sends to the agent with PID “RecipientPid” a
% message of the form {found, Value}, where Value is the value associated with the given key, if
% any. If no such value exists, it sends the message not_found.

%% MASTER: spawns buckets, routes requests by hash
hashtable_spawn(HashFun, NBuckets) ->
    %% Spawn one bucket process per slot
    BucketPids = [
        spawn(?MODULE, bucket, [[]])
     || 
        _ <- lists:seq(0, NBuckets - 1) % LOOP ON N
    ],
    hashtable_loop(HashFun, BucketPids).

hashtable_loop(HashFun, BucketPids) ->
    receive
        {insert, Key, Value} ->
            %% +1 because lists:nth is 1-indexed, hash returns 0-based
            lists:nth(HashFun(Key) + 1, BucketPids) ! {insert, Key, Value},
            hashtable_loop(HashFun, BucketPids);
        {lookup, Key, AnswerPid} ->
            lists:nth(HashFun(Key) + 1, BucketPids) ! {lookup, Key, AnswerPid},
            hashtable_loop(HashFun, BucketPids)
    end.

%% BUCKET: stores list of {Key, Value} tuples
bucket(Content) ->
    receive
        {insert, Key, Value} ->
            %% keystore: update if key exists, insert if not (upsert)
            NewContent = lists:keystore(Key, 1, Content, {Key, Value}),
            bucket(NewContent);
        {lookup, Key, AnswerPid} ->
            case lists:keyfind(Key, 1, Content) of
                false -> AnswerPid ! not_found;
                {_, Value} -> AnswerPid ! {found, Value}
            end,
            bucket(Content)
    end.

%% USAGE:
%% HT = spawn(?MODULE, hashtable_spawn, [fun(K) -> K rem 7 end, 7]),
%% HT ! {insert, 15, "Apple"},
%% HT ! {lookup, 15, self()}, receive {found, V} -> V end.
