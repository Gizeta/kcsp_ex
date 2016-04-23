defmodule KcspEx do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(KcspEx.Proxy, [])
    ]

    opts = [strategy: :one_for_one, name: KcspEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
