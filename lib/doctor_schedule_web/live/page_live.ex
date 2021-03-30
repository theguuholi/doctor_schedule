defmodule DoctorScheduleWeb.PageLive do
  use DoctorScheduleWeb, :live_view
  alias DoctorSchedule.Appointments
  alias DoctorScheduleWeb.PageView

  alias Phoenix.View

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> create_calendar}
  end

  @impl true
  def render(assigns) do
    View.render(PageView, "index.html", assigns)
  end

  defp create_calendar(socket) do
    days = Appointments.create_calendar(Timex.now())
    assign(socket, days: days)
  end
end
