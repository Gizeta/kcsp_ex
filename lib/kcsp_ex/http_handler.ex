defmodule KcspEx.HttpHandler do
  import Plug.Conn
  alias KcspEx.Cache
  require Logger

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{req_type: :api, cache_token: token}}=conn, _opts) do
    case fetch_data(conn) do
      {:ok, resp} ->
        Cache.put(token, resp.body)
        Logger.info("API #{token} #{resp.status_code}")
        %{conn | resp_headers: filter_resp_header(resp.headers)}
        |> send_resp(resp.status_code, resp.body)
      {:error, reason} ->
        Cache.put(token, reason)
        Logger.error("API #{token} 500 #{reason}")
        conn
        |> send_resp(500, reason)
    end
  end
  def call(%Plug.Conn{assigns: %{req_type: :cache, cache_token: token}}=conn, _opts) do
    case fetch_data(conn) do
      {:ok, resp} ->
        Cache.put(token, resp.body)
        Logger.info("CACHE #{token} #{resp.status_code}")
        %{conn | resp_headers: filter_resp_header(resp.headers)}
        |> send_resp(resp.status_code, resp.body)
      {:error, reason} ->
        Cache.del(token)
        Logger.error("CACHE #{token} 500 #{reason}")
        conn
        |> send_resp(500, reason)
    end
  end
  def call(conn, _opts) do
    # TODO: Check edgurgel/httpoison#97 whether there is a better solution for streaming.
    case fetch_data(conn) do
      {:ok, resp} ->
        %{conn | resp_headers: filter_resp_header(resp.headers)}
        |> send_resp(resp.status_code, resp.body)
      {:error, reason} ->
        Logger.error("PIPE #{conn.assigns.url} 500 #{reason}")
        conn
        |> send_resp(500, reason)
    end
  end

  defp fetch_data(conn) do
    url    = conn.assigns.url
    method = String.to_atom(conn.method)
    body   = conn.assigns.body

    HTTPoison.request(method, url, body, filter_req_header(conn.req_headers))
  end

  defp filter_req_header(headers) do
    # TODO: Remove this line after edgurgel/httpoison#81 is closed.
    List.keydelete(headers, "accept-encoding", 0)
  end

  defp filter_resp_header(headers) do
    List.keydelete(headers, "Transfer-Encoding", 0)
  end
end
