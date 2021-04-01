defmodule DoctorSchedule.Appointments.Core.Calendar do
  defstruct current_date: nil,
            first_week_day: nil,
            end_week_day: nil,
            days: nil,
            current_month: nil,
            days_of_week: nil,
            schedules: nil,
            next_one: nil,
            is_today: false

  use Timex
  alias DoctorSchedule.Appointments.Core.Day
  alias DoctorSchedule.Appointments.Core.Schedules
  @week_start :sun
  def new(current_date, current_user_id) do
    %__MODULE__{current_date: current_date}
    |> get_beginning_of_week
    |> get_end_of_week
    |> build_calendar_days
    |> build_day_name
    |> build_current_month
    |> get_all_appointments_from_specific_day(current_user_id)
    |> next_one
    |> is_today?
  end

  defp get_all_appointments_from_specific_day(calendar, current_user_id) do
    schedules = Schedules.get_all_appointments(calendar.current_date, current_user_id)
    %__MODULE__{calendar | schedules: schedules}
  end

  defp is_today?(calendar) do
    if Day.is_today?(calendar.current_date) do
      %__MODULE__{calendar | is_today: true}
    else
      calendar
    end
  end

  defp next_one(calendar) do
    if Day.is_today?(calendar.current_date) do
      schedules = calendar.schedules
      appointments = schedules.morning_appointments ++ schedules.afternoon_apointments
      next_one = Enum.find(appointments, &NaiveDateTime.compare(&1.date, NaiveDateTime.utc_now()))
      %__MODULE__{calendar | next_one: next_one}
    else
      calendar
    end
  end

  def calendar_event(current_date, current_user_id, :next_month) do
    current_date = Timex.shift(current_date, months: 1)
    new(current_date, current_user_id)
  end

  def calendar_event(current_date, current_user_id, :previous_month) do
    current_date = Timex.shift(current_date, months: -1)
    new(current_date, current_user_id)
  end

  defp build_current_month(calendar) do
    current_month = Timex.format!(calendar.current_date, "%B %Y", :strftime)
    %__MODULE__{calendar | current_month: current_month}
  end

  defp build_day_name(calendar) do
    days_of_week = [7, 1, 2, 3, 4, 5, 6] |> Enum.map(&Timex.day_shortname/1)
    %__MODULE__{calendar | days_of_week: days_of_week}
  end

  defp get_beginning_of_week(%__MODULE__{current_date: current_date} = calendar) do
    first_week_day =
      current_date
      |> Timex.beginning_of_month()
      |> Timex.beginning_of_week(@week_start)

    %__MODULE__{calendar | first_week_day: first_week_day}
  end

  defp get_end_of_week(%__MODULE__{current_date: current_date} = calendar) do
    end_week_day =
      current_date
      |> Timex.end_of_month()
      |> Timex.end_of_week(@week_start)

    %__MODULE__{calendar | end_week_day: end_week_day}
  end

  defp build_calendar_days(calendar) do
    interval = Interval.new(from: calendar.first_week_day, until: calendar.end_week_day)
    days = Enum.map(interval, &Day.new(&1, calendar.current_date))
    %__MODULE__{calendar | days: days}
  end
end
