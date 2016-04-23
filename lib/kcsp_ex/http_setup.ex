defmodule KcspEx.HttpSetup do
  import Plug.Conn
  import KcspEx.ConnTool
  import KcspEx.GameTool
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:url, build_url(conn))
    |> assign(:body, build_body(conn))
    |> assign_cache_info
  end
end
