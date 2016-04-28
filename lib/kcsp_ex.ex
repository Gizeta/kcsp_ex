defmodule KcspEx do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(KcspEx.Proxy, []),
      supervisor(Task.Supervisor, [[name: KcspEx.SSLSupervisor]]),
      worker(KcspEx.Cache, []),
      worker(KcspEx.TTLChecker, [])
    ]

    opts = [strategy: :one_for_one, name: KcspEx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
