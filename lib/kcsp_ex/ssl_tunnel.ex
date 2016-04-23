defmodule KcspEx.SSLTunnel do
  alias KcspEx.SSLStream
  require Logger

  def tunnel_transmission(conn) do
    conn
    |> start_tunnel
    |> close_tunnel
  end

  defp start_transmission(to, from) do
    {:ok, pid} = Task.Supervisor.start_child(
      KcspEx.SSLSupervisor,
      fn -> SSLStream.stream(to, from, self()) end)
    :gen_tcp.controlling_process(from, pid)
  end

  defp start_tunnel(%Plug.Conn{assigns: %{ssl_connection_status: :error}} = conn),
    do: conn
  defp start_tunnel(conn) do
    client_socket = conn.assigns.client_socket
    remote_socket = conn.assigns.remote_socket

    start_transmission(remote_socket, client_socket)
    start_transmission(client_socket, remote_socket)
    conn
  end

  defp close_tunnel(%Plug.Conn{assigns: %{ssl_connection_status: :error}} = conn),
    do: conn
  defp close_tunnel(conn) do
    receive do
      :connection_closed ->
        Logger.info("Tunnel #{conn.assigns.host}:#{conn.assigns.port} closed")
        conn
    end
  end
end
