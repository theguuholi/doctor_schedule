defmodule DoctorSchedule.Shared.Cache.Ets.Implementations.ScheduleCache do
  @conn :redis_server

  def get(key), do: Redix.command(@conn, ["GET", key]) |> decode_value()

  def save(key, value), do: Redix.command(@conn, ["SET", key, encode_value(value)])

  # Wrappers
  defp decode_value({:ok, nil}), do: {:not_found, "not found"}

  defp decode_value({:ok, value}) do
    {:ok, binary} =
      value
      |> Base.decode16()

    {:ok, binary |> :erlang.binary_to_term()}
  end

  defp encode_value(value), do: value |> :erlang.term_to_binary() |> Base.encode16()
  def delete(key), do: Redix.command(@conn, ["DEL", key])
end
