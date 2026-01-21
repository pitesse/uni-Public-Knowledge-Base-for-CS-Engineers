-module(ex3).

-export([broker/1]).

% Exercise 3, Erlang (11 pts)
% Define the main function of a broker process for centralized PID-less interaction among processes. The broker
% must respond to these messages:
% • {new, Pid, Id} to bind the local broker identifier Id to the PID Pid;
% • {send, Id, Msg} to send Msg to the process having the local broker identifier Id;
% • {delete_id, Id} to delete the local broker identifier binding for Id;
% • {delete_pid, Pid} to delete the local data for PID Pid;
% • {broadcast, Msg} to send Msg to all the processes known by the broker;
% • stop to stop the broker.
% You can use the following OTP functions, if you need them:
% 
% maps:remove(Key, Map), to remove Key from Map
% maps:filtermap(F/2, Map), which is a filter, where F/2 takes a pair (Key, Value) and returns a Boolean
% maps:foreach(F/2, Map), which runs F/2 on all the pairs (Key, Value) in Map.

broker(Map) ->
    receive
        {new, Pid, Id}     -> broker(Map#{Id => Pid});
        {send, Id, Msg}    -> #{Id := P} = Map, P ! Msg, broker(Map);
        {delete_id, Id}    -> broker(maps:remove(Id, Map));
        {delete_pid, Pid}  -> broker(maps:filtermap(fun(_,V) -> V =/= Pid end, Map));
        {broadcast, Msg}   -> maps:foreach(fun(_,V) -> V ! Msg end, Map), broker(Map);
        stop               -> ok
    end.