defmodule DoctorSchedule.Appointments.Core.Calendar do
  use Timex
  @week_start :sun
  def create(current_date) do
    current_date
    |> get_beginning_of_week
    |> get_end_of_week
    |> build_calendar_days
  end

  defp get_beginning_of_week(current_date) do
    first_week_day =
      current_date
      |> Timex.beginning_of_month()
      |> Timex.beginning_of_week(@week_start)

    {current_date, first_week_day}
  end

  defp get_end_of_week({current_date, first_week_day}) do
    end_week_day =
      current_date
      |> Timex.end_of_month()
      |> Timex.end_of_week(@week_start)

    {current_date, first_week_day, end_week_day}
  end

  defp build_calendar_days(params) do
    {current_date, first_week_day, end_week_day} = params
    interval = Interval.new(from: first_week_day, until: end_week_day)
    Enum.map(interval, &create_day(&1, current_date))
  end

  defp create_day(date, current_date) do
    #   <li class="active">2</li>
    #   <li class="fullday">5</li> %>
    %{date: date, type: day_type(date, current_date)}
  end

  defp day_type(date, current_date) do
    cond do
      is_today?(date) -> "today"
      is_weekend?(date) -> "unavailable"
      is_other_month?(date, current_date) -> "unavailable"
      is_past_month?(date, current_date) -> "unavailable"
      true -> "normal-day"
    end
  end

  defp is_today?(date) do
    Map.take(date, [:year, :month, :day]) ==
      Map.take(Timex.now(), [:year, :month, :day])
  end

  defp is_weekend?(date) do
    week_day = Timex.weekday(date)
    week_day == 6 || week_day == 7
  end

  defp is_other_month?(date, current_date) do
    Map.take(date, [:year, :month]) != Map.take(current_date, [:year, :month])
  end

  defp is_past_month?(date, current_date) do
    Timex.compare(date, current_date) == -1
  end
end
