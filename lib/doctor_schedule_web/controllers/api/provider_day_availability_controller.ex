defmodule DoctorScheduleWeb.Api.ProviderDayAvailabilityController do
  use DoctorScheduleWeb, :controller
  action_fallback DoctorScheduleWeb.FallbackController

  alias DoctorSchedule.Appointments.Services.DayAvailabilityService

  def show(conn, %{
        "date" => date,
        "provider_id" => provider_id
      }) do
    date = Date.from_iso8601!(date)

    days_month_availability =
      DayAvailabilityService.execute(provider_id, date)
      |> IO.inspect()

    conn
    |> json(days_month_availability)
  end
end
