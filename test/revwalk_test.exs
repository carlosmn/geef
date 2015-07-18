defmodule RevwalkTest do
  use ExUnit.Case
  use Geef
  import RepoHelpers


  setup do
    {repo, path, head, boring_ancestor} = tmp_commit_line
    Process.link(repo)
    {:ok, walk} = Repository.revwalk(repo)
    on_exit(fn -> File.rm_rf!(path) end)
    {:ok, [walk: walk, head: head, boring_ancestor: boring_ancestor]}
  end

  test "walk and count", meta do
    walk = meta[:walk]
    Revwalk.push(walk, meta[:head])
    Revwalk.hide(walk, meta[:boring_ancestor])
    assert 3 = count_walk(walk)
  end

  defp count_walk walk, acc \\ 0
  defp count_walk walk, acc do
    case Revwalk.next(walk) do
      {:ok, _} -> count_walk(walk, acc + 1)
      {:error, :iterover} -> acc
    end
  end
end
