-module(ex3).

-export([delay/1, promise/2, force/1]).

% Exercise 3, Erlang (11 pts)
% Consider the delay-force construct presented in class to implement call-by-need in Scheme.
% We want to implement an Erlang version, where promises are Erlang processes.
% The interface of the construct is the following:
% • delay(<function>), where <function> is a thunk -- we cannot pass arbitrary code as in Scheme, so we need
%   a thunk: why?
% • force(<Pid>), where <Pid> is the process id of the promise.

delay(Thunk) ->
    % false = not yet computed
    spawn(?MODULE, promise, [Thunk, false]).

promise(Thunk, false) ->
    receive
        {value, Pid} ->
            V = Thunk(),
            Pid ! {self(), V},
            promise(V, true)
    end;
promise(CachedValue, true) ->
    receive
        {value, Pid} ->
            Pid ! {self(), CachedValue},
            promise(CachedValue, true)
    end.

force(PromisePid) ->
    PromisePid ! {value, self()},
    receive
        {PromisePid, V} -> V
    end.
