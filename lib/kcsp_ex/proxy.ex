defmodule KcspEx.Proxy do
  use Plug.Builder

  plug Plug.Logger
  plug KcspEx.HttpsHandler
  plug KcspEx.HttpSetup
  plug KcspEx.CacheLookup
  plug KcspEx.HttpHandler

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 8099
  end
end
