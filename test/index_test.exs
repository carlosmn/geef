defmodule IndexTest do
  use ExUnit.Case
  use Geef
  alias Geef.Index
  import RepoHelpers


  setup do
    {repo, path} = tmp_bare()
    Process.link(repo)
    on_exit(fn -> File.rm_rf!(path) end)
    {:ok, [repo: repo, path: path]}
  end

  test "add an entry to the index", meta do
    repo = meta[:repo]

    content = "This is some text that will go in a file"
    {:ok, odb} = Repository.odb(repo)
    {:ok, id} = Odb.write(odb, content, :blob)
    assert id == Oid.parse("c300118399f01fe52b316061b5d32beb27e0adfd")

    {:ok, idx} = Index.new
    {now_mega, now_secs, _} = :os.timestamp()
    time = now_mega * 1000000 + now_secs

    entry = %Geef.Index.Entry{mode: 0o100644, id: id, path: "README", size: byte_size(content), mtime: time}
    :ok = Index.add(idx, entry)

    {:ok, tree_id} = Index.write_tree(idx, repo)
    expected = Oid.parse("5a20bbbf65ea75ad4d9f995d179156824ccca3a1")
    assert tree_id == expected

    {:ok, entry1} = Index.get(idx, "README", 0)
#    entry2 = idx["README"]

#    assert entry1 == entry2
    assert entry1.size == byte_size(content)

    Repository.stop(repo)
  end

end
