defmodule DoctorScheduleWeb.PageLive do
  use DoctorScheduleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  @impl true
  def render(assigns) do
    ~L"""

    <hr />
    Count <%= @count %>
    <button phx-click="inc">inc</button>
    <button phx-click="dec">dec</button>
    <button phx-click="zer">zerar</button>
    """
  end

  @impl true
  def handle_event("inc", _params, socket) do
    {:noreply, socket |> assign(count: socket.assigns.count + 1)}
  end

  @impl true
  def handle_event("dec", _params, socket) do
    {:noreply, socket |> assign(count: socket.assigns.count - 1)}
  end

  @impl true
  def handle_event("zer", _params, socket) do
    {:noreply, socket |> assign(count: 0)}
  end
end
