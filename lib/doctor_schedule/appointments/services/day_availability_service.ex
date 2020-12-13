defmodule DoctorSchedule.Appointments.Services.DayAvailabilityService do
  alias DoctorSchedule.Appointments.Repositories.ProviderRepository

  def execute(provider_id, date) do
    appointments = ProviderRepository.all_day_fom_provider(provider_id, date)

    8..19
    |> Enum.map(&%{hour: &1, available: is_available?(&1, appointments, date)})
  end

  defp is_available?(hour, appointments, date) do
    !(appointments
      |> Enum.find(&(&1.date.hour == hour))) &&
      is_after?(hour, date)
  end

  defp is_after?(hour, date) do
    date = %NaiveDateTime{
      year: date.year,
      month: date.month,
      day: date.day,
      hour: hour,
      minute: 0,
      second: 0,
      microsecond: {0, 0}
    }

    NaiveDateTime.utc_now()
    |> NaiveDateTime.compare(date) == :lt
  end
end
