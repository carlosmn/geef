%%%-------------------------------------------------------------------
%%% @author Carlos Martín Nieto <cmn@dwim.me>
%%% @copyright (C) 2014, Carlos Martín Nieto
%%% @doc
%%%
%%% @end
%%% Created : 18 May 2014 by Carlos Martín Nieto <cmn@dwim.me>
%%%-------------------------------------------------------------------
-module(geef_config).

-behaviour(gen_server).

%% API
-export([start_link/1]).
-export([open/1]).
-export([set/3]).
-export([get_bool/2]).
-export([get_string/2]).
-export([stop/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {handle}).

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Handle) ->
    gen_server:start_link(?MODULE, Handle, []).

%% @doc Open a configuration file
-spec open(iolist()) -> {ok, pid()} | {error, term()}.
open(Path) ->
    case geef_nif:config_open(Path) of
	{ok, Handle} ->
	    start_link(Handle);
	Error ->
	    Error
    end.

%% @doc Set a value in the configuration
set(Pid, Name, Val) when is_boolean(Val) ->
    gen_server:call(Pid, {set_bool, Name, Val});
set(Pid, Name, Val) when is_list(Val) or is_binary(Val) ->
    gen_server:call(Pid, {set_string, Name, Val}).

get_bool(Pid, Name) ->
    gen_server:call(Pid, {get_bool, Name}).

get_string(Pid, Name) ->
    gen_server:call(Pid, {get_string, Name}).

stop(Pid) ->
    gen_server:call(Pid, stop).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @private
init(Handle) ->
    {ok, #state{handle=Handle}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({set_bool, Name, Val}, _From, State = #state{handle=Handle}) ->
    Reply = geef_nif:config_set_bool(Handle, Name, Val),
    {reply, Reply, State};

handle_call({get_bool, Name}, _From, State = #state{handle=Handle}) ->
    Reply = geef_nif:config_get_bool(Handle, Name),
    {reply, Reply, State};

handle_call({set_string, Name, Val}, _From, State = #state{handle=Handle}) ->
    Reply = geef_nif:config_set_string(Handle, Name, Val),
    {reply, Reply, State};

handle_call({get_string, Name}, _From, State = #state{handle=Handle}) ->
    Reply = geef_nif:config_get_string(Handle, Name),
    {reply, Reply, State};

handle_call(stop, _From, State) ->
    {stop, normal, ok, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
