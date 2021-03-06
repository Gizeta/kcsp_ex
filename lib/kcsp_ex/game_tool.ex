defmodule KcspEx.GameTool do
  import Plug.Conn

  @kcs_ip ["203.104.209.7",
           "203.104.209.71",
           "203.104.209.87",
           "125.6.184.16",
           "125.6.187.205",
           "125.6.187.229",
           "125.6.187.253",
           "125.6.188.25",
           "203.104.248.135",
           "125.6.189.7",
           "125.6.189.39",
           "125.6.189.71",
           "125.6.189.103",
           "125.6.189.135",
           "125.6.189.167",
           "125.6.189.215",
           "125.6.189.247",
           "203.104.209.23",
           "203.104.209.39",
           "203.104.209.55",
           "203.104.209.102"]
  @cache ["api_start2"]

  def assign_cache_info(%Plug.Conn{host: host, method: "POST", path_info: ["kcsapi" | [path]]} = conn)
      when host in @kcs_ip and path in @cache do
    conn
    |> assign(:req_type, :cache)
    |> assign(:cache_token, path)
  end
  def assign_cache_info(%Plug.Conn{host: host, method: "POST", path_info: ["kcsapi" | _]} = conn)
      when host in @kcs_ip do
    conn
    |> assign(:req_type, :api)
    |> assign(:cache_token, generate_cache_token(conn))
  end
  def assign_cache_info(conn) do
    conn
    |> assign(:req_type, :pass)
  end

  defp generate_cache_token(conn) do
    %Plug.Conn{assigns: %{body: body}, request_path: path} = conn
    token = Regex.run(~r/token=([0-9a-f]+)/, body) |> Enum.at(1)
    hash = :crypto.hash(:md4, path <> body)
    token <> " " <> hash
  end
end
