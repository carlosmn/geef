defmodule ConfigTest do
  use ExUnit.Case
  use Geef
  import RepoHelpers


  setup do
    {repo, path} = tmp_bare
    Process.link(repo)
    {:ok, config} = Repository.config(repo)
    on_exit(fn -> File.rm_rf!(path) end)
    {:ok, [config: config, path: path]}
  end

  test "write and get a boolean", meta do
    config = meta[:config]
    var = "core.logallrefupdates"
    assert :ok = Config.set(config, var, true)
    assert {:ok, true} = Config.get_bool(config, var)
  end

  test "write and get a string", meta do
    config = meta[:config]
    var = "user.name"
    val = "Random J. Hacker"
    assert :ok = Config.set(config, var, val)
    assert {:ok, ^val} = Config.get_string(config, var)
  end

end
