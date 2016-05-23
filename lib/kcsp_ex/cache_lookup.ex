defmodule KcspEx.CacheLookup do
  import Plug.Conn
  alias KcspEx.Cache
  require Logger

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{cache_token: cache_token}}=conn, _opts) do
    [api_token | _] = String.split(cache_token)
    case Cache.get(api_token) do
      {:ok, ^cache_token} ->
        case Cache.get(cache_token) do
          {:ok, "__UNAVAILABLE__"} ->
            conn
            |> send_resp(503, "UNAVAILABLE")
            |> halt
          {:ok, body} ->
            conn
            |> put_resp_header("content-type", "text/plain")
            |> send_resp(200, body)
            |> halt
          :not_found ->
            conn
            |> send_resp(404, "WRONG TOKEN")
            |> halt
          _ ->
            conn
            |> send_resp(500, "DB ERROR")
            |> halt
        end
      {:ok, old_token} ->
        Cache.put(api_token, cache_token)
        Cache.put(cache_token, "__UNAVAILABLE__")
        Cache.del(old_token)
        conn
      :not_found ->
        Cache.put(api_token, cache_token)
        Cache.put(cache_token, "__UNAVAILABLE__")
        conn
      _ ->
        conn
        |> send_resp(500, "DB ERROR")
        |> halt
    end
  end
  def call(conn, _opts), do: conn
end
