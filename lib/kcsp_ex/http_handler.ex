defmodule KcspEx.HttpHandler do
  import Plug.Conn
  import KcspEx.ConnTool

  def init(opts), do: opts

  def call(conn, _opts) do
    url    = build_url(conn)
    method = String.to_atom(conn.method)
    body   = build_body(conn)

    case HTTPoison.request(method, url, body, conn.req_headers) do
      {:ok, resp} ->
        headers = List.keydelete(resp.headers, "Transfer-Encoding", 0)
        %{conn | resp_headers: headers}
        |> send_resp(resp.status_code, resp.body)
      {:error, reason} ->
        conn
        |> send_resp(500, reason)
    end
  end
end
