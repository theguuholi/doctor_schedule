defmodule DoctorSchedule.Counters do
  alias DoctorSchedule.Counters.Core

  def new(), do: Core.new()

  def zer(counters, name) do
    Core.zer(counters, name)
  end

  def dec(counters, name) do
    Core.dec(counters, name)
  end

  def inc(counters, name) do
    Core.inc(counters, name)
  end

  def add_counter(counters) do
    Core.add_counters(counters)
  end
end
