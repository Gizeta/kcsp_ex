defmodule KcspEx.ConnTool do
  import Plug.Conn

  @spec build_url(%Plug.Conn{}) :: binary
  def build_url(%Plug.Conn{host: host, port: port, request_path: path, query_string: qs}) do
    url = host <> ":" <> Integer.to_string(port) <> path
    if qs == "", do: url, else: url <> "?" <> qs
  end

  @spec build_body(%Plug.Conn{}, binary) :: binary
  def build_body(conn, chunked \\ "") do
    case read_body(conn) do
      {:ok, body, _} -> chunked <> body
      {:more, body, conn} -> build_body(conn, chunked <> body)
    end
  end
end
