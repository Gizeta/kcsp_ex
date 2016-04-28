defmodule KcspEx.Cache do
  use GenServer

  def start_link do
    {:ok, db} = :eleveldb.open('/tmp/kcsp', [create_if_missing: true])
    GenServer.start_link(__MODULE__, db, [name: :cache])
  end

  def get(key) do
    GenServer.call(:cache, {:get, key})
  end

  def exists?(key) do
    GenServer.call(:cache, {:exist, key})
  end

  def put(key, value) do
    GenServer.cast(:cache, {:put, key, value})
  end

  def del(key) do
    GenServer.cast(:cache, {:delete, key})
  end

  def handle_call({:get, key}, _from, db) do
    {:ok, value} = :eleveldb.get(db, key, [])
    {:reply, value, db}
  end

  def handle_call({:exist, key}, _from, db) do
    case :eleveldb.get(db, key, []) do
      {:ok, _} -> {:reply, true, db}
      _ -> {:reply, false, db}
    end
  end

  def handle_cast({:put, key, value}, db) do
    :ok = :eleveldb.put(db, key, value, [])
    {:noreply, db}
  end

  def handle_cast({:delete, key}, db) do
    :ok = :eleveldb.delete(db, key, [])
    {:noreply, db}
  end

  def terminate(_reason, db) do
    :eleveldb.close(db)
  end
end
