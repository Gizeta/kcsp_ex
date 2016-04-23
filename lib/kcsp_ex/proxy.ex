defmodule KcspEx.Proxy do
  use Plug.Builder

  plug KcspEx.HttpsHandler
  plug KcspEx.HttpHandler

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 8099
  end
end
