require Record

defmodule Geef.Object do
  defstruct type: nil, id: nil, handle: nil, repo: nil

  def lookup(repo, id) do
    case :geef_repo.lookup_object(repo, id) do
      {:ok, type, handle} ->
        {:ok, %Geef.Object{type: type, id: id, handle: handle, repo: repo}}
      error ->
        error
    end
  end

  def lookup(repo, id, type) do
    case lookup(repo, id) do
      {:ok, obj = %Geef.Object{type: ^type}} ->
        {:ok, obj}
      {:ok, _obj} ->
        {:error, :type_mismatch}
      error ->
        error
    end
  end

  def lookup!(repo, id) do
    case lookup(repo, id) do
      {:ok, obj} ->
        obj
      {:error, err} ->
        raise err
    end
  end

end
