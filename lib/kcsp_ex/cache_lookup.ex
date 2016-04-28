defmodule KcspEx.CacheLookup do
  import Plug.Conn
  alias KcspEx.Cache
  require Logger

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{cache_token: token}}=conn, _opts) do
    if Cache.exists?(token) do
      case Cache.get(token) do
        "__REQ__" ->
          conn
          |> send_resp(404, "__UNAVAILABLE__")
          |> halt
        body ->
          conn
          |> put_resp_header("content-encoding", "gzip")
          |> put_resp_header("content-type", "text/plain")
          |> send_resp(200, body)
          |> halt
      end
    else
      Cache.put(token, "__REQ__")
      conn
    end
  end
  def call(conn, _opts), do: conn
end
