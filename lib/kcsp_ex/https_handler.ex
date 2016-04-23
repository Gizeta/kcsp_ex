defmodule KcspEx.HttpsHandler do
  import Plug.Conn
  alias KcspEx.SSLTunnel

  @established_message "HTTP/1.1 200 Connection established\r\n\r\n"

  def init(opts), do: opts

  def call(%Plug.Conn{method: "CONNECT"} = conn, _opts) do
    conn
    |> assign_client_socket
    |> establish_connection
    |> SSLTunnel.tunnel_transmission
    |> Map.put(:state, :sent)
    |> halt
  end
  def call(conn, _opts), do: conn

  defp assign_client_socket(conn),
    do: assign(conn, :client_socket, conn.adapter |> elem(1) |> elem(1))

  defp parse_remote_server(conn) do
    [host, port] = String.split(conn.request_path, ":")
    {String.to_char_list(host), String.to_integer(port)}
  end

  defp establish_connection(conn) do
    {host, port} = parse_remote_server(conn)

    {status, socket} = case :gen_tcp.connect(host, port, [:binary, active: false]) do
      {:ok, sock} ->
        :gen_tcp.send(conn.assigns.client_socket, @established_message)
        {:ok, sock}
      _ ->
        {:error, nil}
    end

    conn
    |> assign(:ssl_connection_status, status)
    |> assign(:remote_socket, socket)
  end
end
