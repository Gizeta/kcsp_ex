defmodule KcspEx.Cache do
  def get(key) do
    case SSDB.query ["get", key] do
      {:ok, [value]} -> {:ok, value}
      {status, reason} -> {status, reason}
    end
  end

  def exists?(key) do
    case SSDB.query ["exists", key] do
      {:ok, ["1"]} -> {:ok, true}
      {:ok, ["0"]} -> {:ok, false}
      {status, reason} -> {status, reason}
    end
  end

  def set(key, value, ttl \\ 3600) do
    case SSDB.query ["setx", key, value, ttl] do
      {:ok, ["1"]} -> {:ok}
      {:ok, ["0"]} -> {:fail}
      {status, reason} -> {status, reason}
    end
  end

  def del(key) do
    case SSDB.query ["del", key] do
      {:ok, ["1"]} -> {:ok}
      {:ok, ["0"]} -> {:fail}
      {status, reason} -> {status, reason}
    end
  end
end
