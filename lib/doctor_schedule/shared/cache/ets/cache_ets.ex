defmodule DoctorSchedule.Shared.Cache.Ets.CacheEts do
  use GenServer

  def start_link(name), do: GenServer.start_link(__MODULE__, name, name: name)

  def init(name) do
    :ets.new(name, [:set, :public, :named_table])
    {:ok, name}
  end

  def handle_cast({:put, key, value}, name) do
    :ets.insert(name, {key, value})
    {:noreply, name}
  end

  def handle_cast({:delete, key}, name) do
    :ets.delete(name, key)
    {:noreply, name}
  end

  def handle_call({:get, key}, _from, name) do
    reply =
      :ets.lookup(name, key)
      |> case do
        [] -> {:not_found, []}
        [{_key, value}] -> {:ok, value}
      end

    {:reply, reply, name}
  end
end
