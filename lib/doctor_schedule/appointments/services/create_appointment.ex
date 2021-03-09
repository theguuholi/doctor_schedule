defmodule DoctorSchedule.Appointments.Services.CreateAppointment do
  alias DoctorSchedule.Appointments.Repositories.AppointmentsRepository
  alias DoctorSchedule.Shared.Cache.Ets.Implementations.ScheduleCache
  alias DoctorSchedule.Shared.Repositories.Notification

  def execute(appointment) do
    %{
      "date" => date,
      "provider_id" => provider_id,
      "user_id" => user_id
    } = appointment

    date_cache = date |> NaiveDateTime.from_iso8601!() |> NaiveDateTime.to_date()
    cache_key = "provider-schedules:#{provider_id}:#{date_cache}"

    date =
      date
      |> start_hour()

    cond do
      is_before?(date) ->
        {:error, "You cannot create an appointment in the past"}

      provider_id == user_id ->
        {:error, "You cannot create an appointment to yourself"}

      book_time(date) ->
        {:error, "You can book between 8am until 19pm"}

      AppointmentsRepository.find_by_appointment_date_and_provider(date, provider_id) != nil ->
        {:error, "This appointment is already booked"}

      true ->
        {:ok, appointment} =
          appointment
          |> Map.put("date", date)
          |> AppointmentsRepository.create_appointment()

        ScheduleCache.delete(cache_key)
        Task.async(fn -> send_notification(appointment) end)

        {:ok, appointment}
    end
  end

  def send_notification(appointment),
    do:
      %{
        recipient_id: appointment.provider_id,
        content:
          "New schedule to the Doctor #{appointment.provider.first_name} with patient #{
            appointment.user.first_name
          } in #{format_date(appointment.date)}"
      }
      |> Notification.create()

  defp format_date(date) do
    "#{date.day}/#{date.month}/#{date.year} time: #{date.hour}:#{date.minute}"
  end

  defp book_time(date) do
    hour = date.hour
    hour < 8 || hour > 19
  end

  defp is_before?(date) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.compare(date) == :gt
  end

  defp start_hour(date) do
    date =
      date
      |> NaiveDateTime.from_iso8601!()

    %NaiveDateTime{date | minute: 0, second: 0, microsecond: {0, 0}}
  end
end
