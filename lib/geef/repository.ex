defmodule Geef.Repository do
  import Geef

  def stop(repo), do: :geef_repo.stop(repo)

  def open(path),  do: :geef_repo.open(path)
  def open!(path), do: :geef_repo.open(path) |> assert_ok

  def init(path, bare),  do: :geef_repo.init(path, bare)
  def init!(path, bare), do: :geef_repo.init(path, bare) |> assert_ok

  def odb(repo),  do: :geef_repo.odb(repo)
  def odb!(repo), do: :geef_repo.odb(repo) |> assert_ok

  def discover(path), do: :geef_repo.discover(path)

  def bare?(repo), do: :geef_repo.is_bare(repo)
  def gitdir(repo), do: :geef_repo.path(repo)
  def workdir(repo), do: :geef_repo.workdir(repo)
  def config(repo), do: :geef_repo.config(repo)
  def revwalk(repo), do: :geef_repo.revwalk(repo)

  def reference_names(repo), do: :geef_repo.references(repo)
end
