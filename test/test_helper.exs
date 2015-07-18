ExUnit.start

defmodule RepoHelpers do
  use Geef

  def tmp_bare do
    {a, b, c} = :erlang.timestamp()
    n = node()
    dir = :io_lib.format("geef-~p~p~p~p.git", [n, a, b, c])
    path = Path.join(System.tmp_dir!, dir)
    {:ok, repo} = Repository.init(path, true)
    {repo, path}
  end

  def tmp_commit_line do
    {repo, path} = tmp_bare()
    sig = Signature.now("Geef Test", "test@geef")
    message = "commit message"
    {:ok, idx} = Index.new()
    {:ok, empty_index} = Index.write_tree(idx, repo)

    {:ok, c} = Commit.create(repo, sig, sig, message, empty_index, [])
    {:ok, c} = Commit.create(repo, sig, sig, message, empty_index, [c])
    {:ok, c} = Commit.create(repo, sig, sig, message, empty_index, [c])
    boring_ancestor = c
    {:ok, c} = Commit.create(repo, sig, sig, message, empty_index, [c])
    {:ok, c} = Commit.create(repo, sig, sig, message, empty_index, [c])
    {:ok, c} = Commit.create(repo, sig, sig, message, empty_index, [c])
    head = c

    {repo, path, head, boring_ancestor}
  end
end
