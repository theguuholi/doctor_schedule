defmodule DoctorScheduleWeb.PageLive do
  use DoctorScheduleWeb, :live_view
  alias DoctorSchedule.Appointments
  alias DoctorScheduleWeb.PageView

  alias Phoenix.View

  @impl true
  def mount(_params, %{"current_user" => current_user}, socket) do
    current_date = Timex.now()

    {:ok,
     socket
     |> put_user_socket(current_user)
     |> create_calendar(current_user.id, current_date)}
  end

  @impl true
  def render(assigns) do
    View.render(PageView, "index.html", assigns)
  end

  defp put_user_socket(socket, current_user) do
    assign(socket, current_user: current_user)
  end

  defp pick_date(socket, date) do
    current_date = NaiveDateTime.from_iso8601!(date)
    current_user_id = socket.assigns.current_user.id
    create_calendar(socket, current_user_id, current_date)
  end

  defp create_calendar(socket, current_user_id, current_date) do
    calendar = Appointments.create_calendar(current_date, current_user_id)
    assign(socket, calendar: calendar)
  end

  def calendar_event(socket, event) do
    current_date = socket.assigns.calendar.current_date
    current_user_id = socket.assigns.current_user.id
    calendar = Appointments.calendar_event(current_date, current_user_id, event)
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

  @impl true
  def handle_event("pick-date", %{"date" => date}, socket) do
    {:noreply, pick_date(socket, date)}
  end
end
