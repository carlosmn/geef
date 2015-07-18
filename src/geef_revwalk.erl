%%%-------------------------------------------------------------------
%%% @author Carlos Martín Nieto <cmn@dwim.me>
%%% @copyright (C) 2013, Carlos Martín Nieto
%%% @doc
%%%
%%% @end
%%% Created :  6 Apr 2013 by Carlos Martín Nieto <cmn@dwim.me>
%%%-------------------------------------------------------------------
-module(geef_revwalk).

-behaviour(gen_server).

%% API
-export([start_link/1]).
-export([push/2, hide/2, next/1, sorting/2, simplify_first_parent/1, reset/1, stop/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
     terminate/2, code_change/3]).

-record(state, {handle}).
-include("geef_records.hrl").

%%%===================================================================
%%% API
%%%===================================================================

%% @doc Push a commit. This commit and its parents will be included in
%% the walk as long as they haven't been hidden. At least one commit
%% must be pushed before starting a walk.
-spec push(pid(), geef_oid:oid()) -> ok | {error, binary()}.
push(Pid, Id) ->
    gen_server:call(Pid, {push, Id}).

%% @doc Hide a commit. Hide a commit and its parents. Any Parent of
%% this commit won't be included in the walk.
-spec hide(pid(), geef_oid:oid()) -> ok | {error, binary()}.
hide(Pid, Id) ->
    gen_server:call(Pid, {hide, Id}).


%% @doc Select the sorting method
-spec sorting(pid, atom() | [atom()]) -> ok.
sorting(Pid, Opts) when is_list(Opts) ->
    gen_server:call(Pid, {sort, Opts});
sorting(Pid, Opt) when is_atom(Opt) ->
    gen_server:call(Pid, {sort, [Opt]}).

-spec simplify_first_parent(pid) -> ok.
simplify_first_parent(Pid) ->
    gen_server:call(Pid, simplify_first_parent).

-spec reset(pid) -> ok.
reset(Pid) ->
    gen_server:call(Pid, reset).

%% @doc Next commit in the walk
-spec next(pid) -> {ok, geef_oid:oid()} | {error, iterover}.
next(Pid) ->
    gen_server:call(Pid, next).

%% @doc Stop the revwalk server
stop(Pid) ->
    gen_server:call(Pid, stop).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link(term()) -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Handle) ->
    gen_server:start_link(?MODULE, Handle, []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @private
init(Handle) ->
    {ok, #state{handle=Handle}}.

%% @private
handle_call({sort, Opts}, _From, State = #state{handle=Handle}) ->
    geef_nif:revwalk_sorting(Handle, Opts),
    {reply, ok, State};
handle_call(simplify_first_parent, _From, State = #state{handle=Handle}) ->
    geef_nif:revwalk_simplify_first_parent(Handle),
    {reply, ok, State};
handle_call({push, Oid}, _From, State = #state{handle=Handle}) ->
    Reply = geef_nif:revwalk_push(Handle, Oid, false),
    {reply, Reply, State};
handle_call({hide, Oid}, _From, State = #state{handle=Handle}) ->
    Reply = geef_nif:revwalk_push(Handle, Oid, true),
    {reply, Reply, State};
handle_call(reset, _From, State = #state{handle=Handle}) ->
    geef_nif:revwalk_reset(Handle),
    {reply, ok, State};
handle_call(next, _From, State = #state{handle=Handle}) ->
    Reply = geef_nif:revwalk_next(Handle),
    {reply, Reply, State};
handle_call(stop, _From, State) ->
    {stop, normal, ok, State}.

%% @private
handle_cast(_Msg, State) ->
    {noreply, State}.

%% @private
handle_info(_Info, State) ->
    {noreply, State}.

%% @private
terminate(_Reason, _State) ->
    ok.

%% @private
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
