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
    {_current_date, first_week_day, end_week_day} = params

    Interval.new(from: first_week_day, until: end_week_day)
    |> Enum.map(& &1.day)
  end
end
