defmodule DoctorScheduleWeb.PageLive do
  use DoctorScheduleWeb, :live_view
  alias DoctorSchedule.Counters
  alias DoctorScheduleWeb.PageView
  alias Phoenix.View

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> new() |> insert_days}
  end

  @impl true
  def render(assigns) do
    View.render(PageView, "index.html", assigns)
  end

  defp new(socket), do: assign(socket, counters: Counters.new())

  defp insert_days(socket) do
    assign(socket, days: 1..31 |> Enum.map(& &1))
  end

  defp add(socket) do
    assign(socket, counters: Counters.add_counter(socket.assigns.counters))
  end

  defp zer(socket, name) do
    assign(socket, counters: Counters.zer(socket.assigns.counters, name))
  end

  defp dec(socket, name) do
    assign(socket, counters: Counters.dec(socket.assigns.counters, name))
  end

  defp inc(socket, name) do
    assign(socket, counters: Counters.inc(socket.assigns.counters, name))
  end

  @impl true
  def handle_event("add", _params, socket) do
    {:noreply, add(socket)}
  end

  @impl true
  def handle_event("inc", %{"counter" => name}, socket) do
    {:noreply, inc(socket, name)}
  end

  @impl true
  def handle_event("dec", %{"counter" => name}, socket) do
    {:noreply, dec(socket, name)}
  end

  @impl true
  def handle_event("zer", %{"counter" => name}, socket) do
    {:noreply, zer(socket, name)}
  end
end
