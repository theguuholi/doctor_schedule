defmodule DoctorSchedule.Appointments.Services.MonthAvailabilityService do
  alias DoctorSchedule.Appointments.Repositories.ProviderRepository

  def execute(provider_id, year, month) do
    {:ok, this_month} = Date.new(year, month, 1)
    schedules_month = ProviderRepository.all_month_from_provider(provider_id, year, month)

    today = Date.utc_today().day

    1..Date.days_in_month(this_month)
    |> Enum.map(&%{day: &1, available: is_available?(&1, today, schedules_month)})
  end

  def is_available?(day, today, schedules_month) do
    if day >= today do
      schedules_month
      |> Enum.filter(&(&1.date.day == day))
      |> Enum.count() < 12
    else
      false
    end
  end
end
