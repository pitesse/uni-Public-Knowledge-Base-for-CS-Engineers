-module(ex3).

-export([runit/3]).

% Ex 3
% ERLANG:
% Consider the apply operation (i.e.<*>) in Haskell's Applicative class.
% Define a parallel <*> for Erlang's lists.

runit(Proc, F, X) -> 
    Proc ! {self(), F(X)}.

pmap(F, L) ->
    W = lists:map(fun(X) -> 
                          spawn(?MODULE, runit, [self(), F, X]) 
                  end, L),
    lists:map(fun (P) ->
                      receive
                          {P, V} -> V
                      end
              end, W).

pappl(FL, L) ->
    lists:foldl(fun (X,Y) -> Y ++ X end, [], pmap(fun(F) -> pmap(F, L) end, FL)).