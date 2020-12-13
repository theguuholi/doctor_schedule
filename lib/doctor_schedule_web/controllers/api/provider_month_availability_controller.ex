defmodule DoctorScheduleWeb.Api.ProviderMonthAvailabilityController do
  use DoctorScheduleWeb, :controller
  action_fallback DoctorScheduleWeb.FallbackController

  alias DoctorSchedule.Appointments.Services.MonthAvailabilityService

  def show(conn, %{
        "month" => month,
        "provider_id" => provider_id,
        "year" => year
      }) do
    year = String.to_integer(year)
    month = String.to_integer(month)

    days_month_availability = MonthAvailabilityService.execute(provider_id, year, month)

    conn
    |> json(days_month_availability)
  end
end
