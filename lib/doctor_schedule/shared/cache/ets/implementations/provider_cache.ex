defmodule DoctorSchedule.Shared.Cache.Ets.Implementations.ProviderCache do
  def get(key), do: GenServer.call(CacheEts, {:get, key})
  def save(key, value), do: GenServer.cast(CacheEts, {:put, key, value})
end
