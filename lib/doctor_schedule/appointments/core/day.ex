defmodule DoctorSchedule.Appointments.Core.Day do
  defstruct date: nil, type: nil

  def new(date, current_date) do
    #   <li class="active">2</li>
    #   <li class="fullday">5</li> %>
    %__MODULE__{date: date, type: day_type(date, current_date)}
  end

  defp day_type(date, current_date) do
    cond do
      is_today?(date) -> "today"
      current_date?(date, current_date) -> "active"
      is_weekend?(date) -> "unavailable"
      is_other_month?(date, current_date) -> "unavailable"
      true -> "normal-day"
    end
  end

  def is_today?(date) do
    Map.take(date, [:year, :month, :day]) ==
      Map.take(Timex.now(), [:year, :month, :day])
  end

  defp current_date?(date, current_date) do
    Map.take(date, [:year, :month, :day]) ==
      Map.take(current_date, [:year, :month, :day])
  end

  defp is_weekend?(date) do
    week_day = Timex.weekday(date)
    week_day == 6 || week_day == 7
  end

  defp is_other_month?(date, current_date) do
    Map.take(date, [:year, :month]) != Map.take(current_date, [:year, :month])
  end
end
