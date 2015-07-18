defmodule Geef.Revwalk do
  import Geef
  alias Geef.Object

  def stop(walk), do: :geef_revwalk.stop(walk)

  def open(repo) when is_pid(repo), do: Repository.revwalk(repo)
  def open!(arg), do: open(arg) |> assert_ok

  def push(walk, %Object{type: :commit, id: commit}), do: push(walk, commit)
  def push(walk, commit), do: :geef_revwalk.push(walk, commit)

  def hide(walk, %Object{type: :commit, id: commit}), do: hide(walk, commit)
  def hide(walk, commit), do: :geef_revwalk.hide(walk, commit)

  def simplify_first_parent(walk), do: :geef_revwalk.simplify_first_parent(walk)

  def sorting(walk, flags \\ [])
  def sorting(walk, flags) when is_list(flags) do
    flags = Enum.map(flags, &compile_sorting_flag/1)
    :geef_revwalk.sorting(walk, flags)
  end
  def sorting(walk, flag), do: sorting(walk, [flag])

  def next(walk), do: :geef_revwalk.next(walk)

  def reset(walk), do: :geef_revwalk.reset(walk)

  defp compile_sorting_flag(:topological_sort), do: :toposort
  defp compile_sorting_flag(:time_sort), do: :timesort
  defp compile_sorting_flag(:reverse_sort), do: :reversesort
end
