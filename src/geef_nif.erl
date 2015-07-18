%%% @private
%%% NIF functions, not to be used directly.

-module(geef_nif).
-compile(export_all).

-include("geef_records.hrl").

-on_load(load_enif/0).

-define(NIF_FN, nif_error(?LINE)).

-spec repository_open(iolist()) -> {ok, term()} | {error, term()}.
repository_open(_Val) ->
    nif_error(?LINE).

-spec repository_is_bare(term()) -> boolean().
repository_is_bare(_Handle) ->
    nif_error(?LINE).

-spec repository_get_path(term()) -> binary().
repository_get_path(_Val) ->
    nif_error(?LINE).

-spec repository_get_workdir(term()) -> binary().
repository_get_workdir(_Handle) ->
    nif_error(?LINE).

repository_get_odb(_Val) ->
    nif_error(?LINE).

-spec repository_get_config(term()) -> {ok, term()} | {error, term()}.
repository_get_config(_Val) ->
    nif_error(?LINE).

-spec repository_init(iolist(), boolean()) -> term().
repository_init(_Path, _Bare) ->
    nif_error(?LINE).

-spec repository_discover(iolist()) -> {ok, string()} | error.
repository_discover(_Path) ->
    nif_error(?LINE).

reference_list(_Repo) ->
    nif_error(?LINE).

-spec reference_create(term(), iolist(), geef_ref:type(), iolist() | geef_oid:oid(), boolean()) -> ok | {error, term()}.
reference_create(_Repo, _Refname, _Type, _Target, _Force) ->
    ?NIF_FN.

reference_to_id(_Repo, _Refname) ->
    nif_error(?LINE).

reference_glob(_Repo, _Glob) ->
    nif_error(?LINE).

-spec reference_lookup(term(), binary() | iolist()) -> {ok, geef_ref:type(), binary()} | {error, term()}.
reference_lookup(_RepoHandle, _Refname) ->
    nif_error(?LINE).

-spec reference_iterator(term(), iolist() | undefined) -> {ok, geef_ref:iterator()} | {error, term()}.
reference_iterator(_Repo, _Regexp) ->
    nif_error(?LINE).

-spec reference_next(geef_ref:iterator()) -> {ok, binary(), geef_ref:type(), binary()} | {error, iterover | term()}.
reference_next(_Handle) ->
    nif_error(?LINE).

-spec reference_resolve(term(), binary()) -> {ok, binary(), binary()} | {error, term()}.
reference_resolve(_RepoHandle, _Name) ->
    nif_error(?LINE).

reference_dwim(_Handle, _Name) ->
    ?NIF_FN.

-spec reference_has_log(term(), iolist()) -> {ok, boolean()} | {error, term()}.
reference_has_log(_Handle, _Name) ->
    ?NIF_FN.

-spec reflog_read(term(), iolist()) -> {ok, binary(), binary(), non_neg_integer(), non_neg_integer()} | {error, term()}.
reflog_read(_Handle, _Name) ->
    ?NIF_FN.

-spec reflog_delete(term(), iolist()) -> ok | {error, term()}.
reflog_delete(_Handle, _Name) ->
    ?NIF_FN.

odb_object_exists(_Val, _Val) ->
    nif_error(?LINE).

-spec odb_write(term(), iolist(), atom()) -> term().
odb_write(_Handle, _Contents, _Type) ->
    nif_error(?LINE).

oid_fmt(_Oid) ->
    nif_error(?LINE).

oid_parse(_Sha) ->
    nif_error(?LINE).

object_lookup(_Repo, _Oid) ->
    nif_error(?LINE).

object_id(_Handle) ->
    nif_error(?LINE).

-spec commit_tree_id(term) -> binary().
commit_tree_id(_Handle) ->
    nif_error(?LINE).

-spec commit_tree(term) -> term().
commit_tree(_Handle) ->
    nif_error(?LINE).

commit_create(_RepoHandle, _Ref, _Author, _Committer, _Encoding, _Message, _Tree, _Parents) ->
    ?NIF_FN.

-spec commit_message(term) -> {ok, binary()} | {error, term()}.
commit_message(_CommitHandle) ->
    ?NIF_FN.

-spec tree_bypath(term, iolist()) -> term().
tree_bypath(_TreeHandle, _Path) ->
    nif_error(?LINE).

-spec tree_nth(term, non_neg_integer()) -> term().
tree_nth(_TreeHandle, _Nth) ->
    ?NIF_FN.

-spec tree_count(term) -> non_neg_integer().
tree_count(_Treehandle) ->
    ?NIF_FN.

-spec blob_size(term) -> {ok, integer()} | error.
blob_size(_ObjHandle) ->
    nif_error(?LINE).

-spec blob_content(term) -> {ok, binary()} | error.
blob_content(_ObjHandle) ->
    nif_error(?LINE).

-spec tag_peel(term()) -> {ok, atom(), binary(), term()} | {error, term()}.
tag_peel(_Tag) ->
    ?NIF_FN.

-spec library_version() -> {integer, integer, integer}.
library_version() ->
    nif_error(?LINE).

revwalk_new(_Repo) ->
    ?NIF_FN.

revwalk_push(_Walk, _Id, _Hide) ->
    ?NIF_FN.

revwalk_next(_Walk) ->
    ?NIF_FN.

revwalk_sorting(_Walk, _Sort) ->
    ?NIF_FN.

revwalk_simplify_first_parent(_Walk) ->
    ?NIF_FN.

revwalk_reset(_Walk) ->
    ?NIF_FN.

index_new() ->
    ?NIF_FN.

index_write(_Handle) ->
    ?NIF_FN.

index_write_tree(_Handle) ->
    ?NIF_FN.

index_write_tree(_Handle, _RepoHandle) ->
    ?NIF_FN.

index_read_tree(_Handle, _TreeHandle) ->
    ?NIF_FN.

-spec index_count(term()) -> non_neg_integer().
index_count(_Handle) ->
    ?NIF_FN.

-spec index_nth(term(), non_neg_integer()) -> {ok, geef_index:entry()} | {error, term()}.
index_nth(_Handle, _Nth) ->
    ?NIF_FN.

-spec index_get(term(), iolist(), non_neg_integer()) -> {ok, geef_index:entry()} | {error, term()}.
index_get(_Handle, _Path, _Stage) ->
    ?NIF_FN.

index_add(_Handle, _Entry) ->
    ?NIF_FN.

index_clear(_Handle) ->
    ?NIF_FN.

-spec signature_default(term()) -> {ok, binary(), binary(), non_neg_integer(), non_neg_integer()} | {error, term()}.
signature_default(_Repo) ->
    ?NIF_FN.

signature_new(_Name, _Email) ->
    ?NIF_FN.

signature_new(_Name, _Email, _Time) ->
    ?NIF_FN.

-spec revparse_single(term(), iolist()) -> {ok, term(), atom(), geef_oid:oid()} | {error, term()}.
revparse_single(_Handle, _Str) ->
    ?NIF_FN.

-spec config_set_bool(term(), iolist(), boolean()) -> ok | {error, term()}.
config_set_bool(_Handle, _Name, _Val) ->
    ?NIF_FN.

-spec config_get_bool(term(), iolist()) -> {ok, boolean()} | {error, term()}.
config_get_bool(_Handle, _Name) ->
    ?NIF_FN.

-spec config_set_string(term(), iolist(), iolist()) -> ok | {error, term()}.
config_set_string(_Handle, _Name, _Val) ->
    ?NIF_FN.

-spec config_get_string(term(), iolist()) -> {ok, binary()} | {error, term()}.
config_get_string(_Handle, _Name) ->
    ?NIF_FN.

-spec config_open(iolist()) -> {ok, term()} | {error, term()}.
config_open(_Path) ->
    ?NIF_FN.

nif_error(Line) ->
    erlang:nif_error({nif_not_loaded,module,?MODULE,line,Line}).

load_enif() ->
    case code:priv_dir(geef) of
        {error, bad_name} ->
            SoName = filename:join("priv", geef);
        Dir ->
            SoName = filename:join(Dir, geef)
    end,
    erlang:load_nif(SoName, 0).
