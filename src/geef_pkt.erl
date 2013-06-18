-module(geef_pkt).

-export([line/1, parse/1, parse_request/1]).

-include("geef_records.hrl").

-define(SHA_LEN, 40).

-spec line(iolist()) -> iolist().
line([]) ->
    [];
line(Text) ->
    % prefix's own size + text size + LF
    Len = 4 + iolist_size(Text) + 1,
    Prefix = io_lib:format("~4.16.0b", [Len]),
    [Prefix, Text, "\n"].

-spec parse(iolist()) -> {{want | have, geef_oid()}, binary()} | {error, ebufs}.
parse(In) ->
    case unpack(In) of
	Err = {error, ebufs} ->
	    Err;
	{Len, Rest} ->
	    parse_pkt(Rest, Len)
    end.

-spec parse_request(iolist()) -> geef_request().
parse_request(In) ->
    case unpack(In) of
	Err = {error, ebufs} ->
	    Err;
	{_, Line} ->
	    %% Split it into request, host, rest (should be empty)
	    [S, H, _] = binary:split(Line, <<0:8>>, [global]),
	    {Service, Path} = service_path(S),
	    <<"host=", Host/binary>> = H,
	    {ok, #geef_request{service=Service, path=Path, host=Host}}
    end.

service_path(<<"git-upload-pack ", Path/binary>>) ->
    {upload_pack, Path};
service_path(<<"git-receive-pack ", Path/binary>>) ->
    {receive_pack, Path}.

-spec unpack(iolist()) -> {error, ebufs} | {non_neg_integer(), binary()}.
unpack(In) ->
    <<BLen:4/binary, Rest/binary>> = iolist_to_binary(In),
    Len = erlang:list_to_integer(unicode:characters_to_list(BLen), 16),
    do_unpack(Len, Rest).

do_unpack(0, Rest) ->
    {0, Rest};
do_unpack(Len, Rest) when Len - 4 > size(Rest) ->
    {error, ebufs};
do_unpack(Len, Rest) ->
    {Len - 4, Rest}.

parse_pkt(In, 0) ->
    {flush, In};
parse_pkt(In, Len) ->
    {Type, NameLen, Rest0} = pkt_type(In),
    LenLF = Len - NameLen, % lets us optionally clean the LF
    {Pkt, Rest1} = case Type of
		       done ->
			   {done, Rest0};
		       _ ->
			   <<Sha:?SHA_LEN/binary, R/binary>> = Rest0,
			   {{Type,  geef_oid:parse(Sha)}, R}
		   end,
    <<_:LenLF/binary, Rest/binary>> = Rest1,
    {Pkt, Rest}.

pkt_type(<<"have ", Rest/binary>>) ->
    {have, 5 + ?SHA_LEN, Rest};
pkt_type(<<"want ", Rest/binary>>) ->
    {want, 5 + ?SHA_LEN, Rest};
pkt_type(<<"done", Rest/binary>>) ->
    {done, 4, Rest}.
