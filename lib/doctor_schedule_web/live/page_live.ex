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
    current_date = Timex.now()
    calendar = Appointments.create_calendar(current_date)
    assign(socket, calendar: calendar, current_date: current_date)
  end

  @impl true
  def handle_event("previous-month", _, socket) do
    current_date = Timex.shift(socket.assigns.current_date, months: -1)
    calendar = Appointments.create_calendar(current_date)
    {:noreply, assign(socket, calendar: calendar, current_date: current_date)}
  end

  @impl true
  def handle_event("next-month", _, socket) do
    current_date = Timex.shift(socket.assigns.current_date, months: 1)
    calendar = Appointments.create_calendar(current_date)
    {:noreply, assign(socket, calendar: calendar, current_date: current_date)}
  end
end
