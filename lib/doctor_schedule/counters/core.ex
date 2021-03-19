defmodule DoctorSchedule.Counters.Core do
  def new(), do: %{}

  def inc(counters, name) do
    Map.put(counters, name, counters[name] + 1)
  end

  def zer(counters, name) do
    Map.put(counters, name, 0)
  end

  def dec(counters, name) do
    Map.put(counters, name, counters[name] - 1)
  end

  def add_counters(counters) do
    Map.put(counters, max_counter_name(counters), 0)
  end

  defp max_counter_name(counters) do
    counters
    |> Map.keys()
    |> Enum.map(&String.to_integer/1)
    |> Enum.max()
    |> Kernel.+(1)
    |> to_string
  rescue
    _e ->
      "1"
  end
end
