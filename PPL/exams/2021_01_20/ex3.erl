-module(ex3).

% ERLANG

% Define a function for a proxy used to avoid to send PIDs; the proxy must react to the following messages:

% - {remember, PID, Name}: associate the value Name with PID.

% - {question, Name, Data}: send a question message containing Data to the PID corresponding
%   to the value Name (e.g. an atom), like in PID ! {question, Data}

% - {answer, Name, Data}: send an answer message containing Data to the PID corresponding to the
%   value Name (e.g. an atom), like in PID ! {answer, Data}

proxy(Table) ->
    receive
        {question, Name, Data} ->
            #{Name := ExtractedName} = Table,
            ExtractedName ! {question, Data},
            proxy(Table);
        {answer, Name, Data} ->
            #{Name := ExtractedName} = Table,
            ExtractedName ! {answer, Data},
            proxy(Table);
        {remember, PID, Name} ->
            proxy(Table#{Name => PID})
    end.
