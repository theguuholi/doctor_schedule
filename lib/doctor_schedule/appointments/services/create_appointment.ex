defmodule DoctorSchedule.Appointments.Services.CreateAppointment do
  alias DoctorSchedule.Appointments

  def execute(appointment) do
    %{
      "date" => date,
      "provider_id" => provider_id,
      "user_id" => user_id
    } = appointment

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

      Appointments.find_by_appointment_date_and_provider(date, provider_id) != nil ->
        {:error, "This appointment is already booked"}

      true ->
        appointment
        |> Map.put("date", date)
        |> Appointments.create_appointment()
    end
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
