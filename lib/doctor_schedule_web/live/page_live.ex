defmodule DoctorScheduleWeb.PageLive do
  use DoctorScheduleWeb, :live_view
  alias DoctorSchedule.Counters
  alias DoctorScheduleWeb.PageView
  alias Phoenix.View

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> insert_days}
  end

  @impl true
  def render(assigns) do
    View.render(PageView, "index.html", assigns)
  end

  defp insert_days(socket) do
    assign(socket, days: 1..31 |> Enum.map(& &1))
  end
end
