defmodule DoctorSchedule.Shared.Cache.Ets.CacheEts do
  use GenServer

  @db :providers

  def start_link(), do: GenServer.start_link(__MODULE__, %{}, name: CacheEts)

  def init(state) do
    :ets.new(@db, [:set, :public, :named_table])
    {:ok, state}
  end

  def handle_cast({:put, key, value}, state) do
    :ets.insert(@db, {key, value})
    {:noreply, state}
  end

  def handle_call({:get, key}, _from, state) do
    reply =
      :ets.lookup(@db, key)
      |> case do
        [] -> {:not_found, []}
        [{_key, value}] -> {:ok, value}
      end

    {:reply, reply, state}
  end
end
