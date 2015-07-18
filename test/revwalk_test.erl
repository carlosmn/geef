-module(revwalk_test).
-compile([export_all]).
-include_lib("eunit/include/eunit.hrl").

repo_test_() ->
    case os:getenv("GEEF_RESOURCES") of
    false ->
        [];
    _ ->
        {foreach, fun start/0, fun stop/1, [fun amount_test/1]}
    end.

start() ->
    BasePath = os:getenv("GEEF_RESOURCES"),
    Path = filename:join([BasePath, "testrepo.git"]),
    {ok, Repo} = geef_repo:open(Path),
    Repo.

count_walk(Walk, Acc) ->
    case geef_revwalk:next(Walk) of
    {ok, _} ->
        count_walk(Walk, Acc + 1);
    {error, iterover} ->
        Acc
    end.

amount_test(Repo) ->
    {ok, Walk} = geef_repo:revwalk(Repo),
    ok = geef_revwalk:push(Walk, "a4a7dce85cf63874e984719f4fdd239f5145052f"),
    Count = count_walk(Walk, 0),
    geef_revwalk:stop(Walk),
    [?_assertEqual(6, Count)].

stop(Repo) ->
    geef_repo:stop(Repo).
