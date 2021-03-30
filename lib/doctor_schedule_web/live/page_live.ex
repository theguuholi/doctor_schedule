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
    assign(socket, calendar: calendar)
  end

  def calendar_event(socket, event) do
    current_date = socket.assigns.calendar.current_date
    calendar = Appointments.calendar_event(current_date, event)
    assign(socket, calendar: calendar)
  end

  @impl true
  def handle_event("previous-month", _, socket) do
    {:noreply, socket |> calendar_event(:previous_month)}
  end

  @impl true
  def handle_event("next-month", _, socket) do
    {:noreply, socket |> calendar_event(:next_month)}
  end
end
