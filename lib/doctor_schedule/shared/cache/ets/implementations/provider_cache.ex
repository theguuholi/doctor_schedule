defmodule DoctorSchedule.Shared.Cache.Ets.Implementations.ProviderCache do
  @db :providers

  def get(key), do: GenServer.call(@db, {:get, key})
  def save(key, value), do: GenServer.cast(@db, {:put, key, value})
  def delete(key), do: GenServer.cast(@db, {:delete, key})
end
