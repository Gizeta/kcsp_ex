defmodule KcspEx.Proxy do
  use Plug.Builder

  plug Plug.Logger
  plug KcspEx.HttpsHandler
  plug KcspEx.HttpSetup
  plug KcspEx.CacheLookup
  plug KcspEx.HttpHandler

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http __MODULE__, [],
      port: Application.get_env(:kcsp_ex, :port)
  end
end
