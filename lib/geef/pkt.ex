require Record

defmodule Geef.Request do
  defstruct Record.extract(:geef_request, from: "src/geef_records.hrl")
end

defmodule Geef.Pkt do
  
  def parse_request(str) do
    case :geef_pkt.parse_request(str) do
      {:ok, {:geef_request, service, path, host}} ->
        {:ok, %Geef.Request{service: service, path: path, host: host}}
      error ->
        error
    end
  end

  def parse(str), do: :geef_pkt.parse(str)
  def line(str), do: :geef_pkt.line(str)

end
