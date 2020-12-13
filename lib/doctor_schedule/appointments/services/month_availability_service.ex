defmodule DoctorSchedule.Appointments.Services.MonthAvailabilityService do
  alias DoctorSchedule.Appointments.Repositories.ProviderRepository

  def execute(provider_id, year, month) do
    {:ok, this_month} = Date.new(year, month, 1)

    schedules_month = ProviderRepository.all_month_from_provider(provider_id, year, month)

    today = Date.utc_today()

    1..Date.days_in_month(this_month)
    |> Enum.map(&%{day: &1, available: is_available?(&1, today, this_month, schedules_month)})
  end

  def is_available?(day, today, this_month, schedules_month) do
    date = %Date{this_month | day: day}

    if Date.compare(date, today) != :lt do
      schedules_month
      |> Enum.filter(&(&1.date.day == day))
      |> Enum.count() < 12
    else
      false
    end
  end
end
