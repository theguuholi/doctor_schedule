defmodule DoctorSchedule.Appointments.Services.DayAvailabilityService do
  alias DoctorSchedule.Appointments.Repositories.ProviderRepository

  def execute(provider_id, date) do
    8..19
    |> Enum.map(&%{hour: &1, available: is_available?(&1, date)})
  end

  defp is_available?(hour, date) do
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
