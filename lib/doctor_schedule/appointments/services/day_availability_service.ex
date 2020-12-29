defmodule DoctorSchedule.Appointments.Services.DayAvailabilityService do
  alias DoctorSchedule.Appointments.Repositories.ProviderRepository
  alias DoctorSchedule.Shared.Cache.Ets.Implementations.ScheduleCache

  def execute(provider_id, date) do
    cache_key = "provider-schedules:#{provider_id}:#{date}"

    ScheduleCache.get(cache_key)
    |> case do
      {:ok, day_availability} ->
        day_availability

      {:not_found, _} ->
        appointments = ProviderRepository.all_day_fom_provider(provider_id, date)

        schedule =
          8..19
          |> Enum.map(&%{hour: &1, available: is_available?(&1, appointments, date)})

        ScheduleCache.save(cache_key, schedule)
        schedule
    end
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
