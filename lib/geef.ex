defmodule Geef do

  defmacro __using__(_) do
    quote do
      alias Geef.Blob
      alias Geef.Commit
      alias Geef.Config
      alias Geef.Index
      alias Geef.Index.Tree
      alias Geef.Object
      alias Geef.Odb
      alias Geef.Oid
      alias Geef.Reference
      alias Geef.Repository
      alias Geef.Revwalk
      alias Geef.Signature
      alias Geef.Tree
      alias Geef.Tag
      alias Geef.TreeEntry
    end
  end

  def assert_ok({:ok, ref}), do: ref
  def assert_ok({:error, error}), do: raise error

end
