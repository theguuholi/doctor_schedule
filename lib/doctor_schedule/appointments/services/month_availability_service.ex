defmodule DoctorSchedule.Appointments.Services.MonthAvailabilityService do
  alias DoctorSchedule.Appointments.Repositories.AppointmentsRepository

  def execute(provider_id, year, month) do
    {:ok, this_month} = Date.new(year, month, 1)

    AppointmentsRepository.all_month_from_provider(provider_id, year, month)
    |> IO.inspect()

    1..Date.days_in_month(this_month)
    |> Enum.map(&%{day: &1, free: true})
  end
end
