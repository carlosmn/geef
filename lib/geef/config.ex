defmodule Geef.Config do
  import Geef
  alias Geef.Repository

  def stop(config), do: :geef_config.stop(config)

  def open(repo) when is_pid(repo), do: Repository.config(repo)
  def open(path), do: :geef_config.open(path)
  def open!(arg), do: open(arg) |> assert_ok

  def set(config, key, value) do
    :geef_config.set(config, make_config_key(key), value)
  end

  def get_bool(config, key) do
    :geef_config.get_bool(config, make_config_key(key))
  end

  def get_string(config, key) do
    :geef_config.get_string(config, make_config_key(key))
  end

  defp make_config_key(key) when is_binary(key), do: String.to_char_list(key)
  defp make_config_key(key), do: key
end
