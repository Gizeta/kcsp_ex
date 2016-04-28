defmodule KcspEx.TTLChecker do
  use GenServer
  alias KcspEx.Cache

  @default_ttl 3600

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    Process.send_after(self(), :check_ttl, @default_ttl * 1000)
    {:ok, state}
  end

  def handle_info(:check_ttl, state) do
    Cache.each(fn key, value ->
      IO.puts(key <> ":" <> value)
      case key do
        "time_" <> item ->
          {timestamp, _} = Integer.parse(value)
          if timestamp + @default_ttl < :os.system_time(:seconds) do
            Cache.del(item)
          end
        _ -> :ok
      end
    end)

    Process.send_after(self(), :check_ttl, @default_ttl * 1000)
    {:noreply, state}
  end
end
