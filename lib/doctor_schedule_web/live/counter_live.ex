defmodule DoctorScheduleWeb.CounterLive do
  use DoctorScheduleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, counters: new())}
  end

  defp new(), do: %{}

  @impl true
  def handle_event("add", _params, socket) do
    counters = socket.assigns.counters

    counter_name =
      counters
      |> Map.keys()
      |> Enum.map(&String.to_integer/1)
      |> Enum.max()
      |> Kernel.+(1)
      |> to_string
      |> IO.inspect()

    counters = Map.put(counters, counter_name, 0)
    {:noreply, assign(socket, counters: counters)}
  rescue
    _e ->
      counters = Map.put(socket.assigns.counters, "1", 0)
      {:noreply, assign(socket, counters: counters)}
  end

  @impl true
  def handle_event("inc", %{"counter" => name}, socket) do
    counters = socket.assigns.counters
    socket = assign(socket, counters: Map.put(counters, name, counters[name] + 1))
    {:noreply, socket}
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
